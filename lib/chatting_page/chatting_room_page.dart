import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pineapple_tok/data/chatting_room.dart';
import 'package:pineapple_tok/data/chatting_comment.dart';
import 'package:pineapple_tok/chatting_page/chat_bubble.dart';
import 'package:pineapple_tok/chatting_page/message_send_bar.dart';

class ChattingRoomPage extends StatefulWidget {
  final ChattingRoom chattingInfo;
  const ChattingRoomPage({Key? key, required this.chattingInfo}) : super(key: key);

  @override
  State<ChattingRoomPage> createState() => _ChattingRoomPageState();
}

class _ChattingRoomPageState extends State<ChattingRoomPage> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // StreamBuilder와 FutureBuilder 사용 시 화면이 계속 새로고침 되는 것을 막기 위한 변수
  ListView _messageData = ListView();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          title: _getAppbarTitle(),
        ),
        body: _buildProfileBody(),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  Widget _getAppbarTitle() {
    String title = '${widget.chattingInfo.chattingRoomName}';
    if (widget.chattingInfo.chattingRoomType == ChattingType.group) {
      title += '    ${widget.chattingInfo.numOfPeople}';
    }
    Text titleText = Text(title);

    return titleText;
  }

  Widget _buildProfileBody() {
    return Column(
      children: [
        Expanded(
          // StreamBuilder를 통해 firestore에 chat 정보가 입력되면 실시간으로 가져온다
          child: _readDataAndMakeMessageList(),
        ),
        MessageSendBar(chattingRoomId: widget.chattingInfo.cid, scrollController: _scrollController),
      ],
    );
  }

  Widget _readDataAndMakeMessageList() {
    return StreamBuilder(
      stream: _firestore
          .collection('chatting').doc('messages').collection('data')
          .doc(widget.chattingInfo.cid).collection('chat')
          .orderBy('time', descending: true).snapshots(), // 첫 로딩 시 가장 마지막 message로 가기 위해 내림차순으로 정렬
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _messageData;
        }

        final chatDocs = snapshot.data!.docs;
        // chat bubble을 만들기 위해서는 async 함수를 호출해야 한다.
        // 이때 StreamBuilder의 builder는 async 함수화가 되지 않는다.
        // 따라서 _makeMessageList 함수 내에서 FutureBuilder를 이용해 async 함수를 호출
        return _makeMessageList(chatDocs);
      },
    );
  }

  Widget _makeMessageList(chatDocs) {
    ChattingMessageHandler handler = ChattingMessageHandler(widget.chattingInfo.cid);
    return FutureBuilder(
      future: handler.getChattingMessages(chatDocs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            _messageData = ListView(
              controller: _scrollController,
              reverse: true, // 첫 로딩 시 가장 마지막 message로 가기 위해 사용
              children: _buildChattingMessage(context, snapshot.data!),
            );
          }
        }

        return _messageData;
      },
    );
  }

  List<Widget> _buildChattingMessage(BuildContext context, List<ChattingMessage> dataList) {
    List<Widget> messageList = [];

    messageList.add(makeChattingCommentWidget(dataList[0]));
    DateTime beforeDate = dataList[0].dateTime;
    for (var data in dataList.sublist(1)) {
      if (_isDifferenceDate(beforeDate, data.dateTime)) {
        messageList.add(_makeDateSeparator(beforeDate));
      }
      messageList.add(makeChattingCommentWidget(data));
      beforeDate = data.dateTime;
    }
    messageList.add(_makeDateSeparator(beforeDate));

    return messageList;
  }

  bool _isDifferenceDate(DateTime d1, DateTime d2) {
    String s1 = DateFormat('yMd').format(d1);
    String s2 = DateFormat('yMd').format(d2);

    if (s1 != s2) {
      return true;
    }

    return false;
  }

  Widget _makeDateSeparator(DateTime datetime) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          DateFormat('y년 M월 d일 EEEE').format(datetime),
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget makeChattingCommentWidget(ChattingMessage message) {
    final curUser = _authentication.currentUser;

    List<Widget> RowChildren = [];
    MainAxisAlignment alignment = MainAxisAlignment.start;

    if (curUser!.uid == message.uid) {
      RowChildren.add(Text(message.getTime()));
      RowChildren.add(_messageBody(message));
      alignment = MainAxisAlignment.end;
    }
    else {
      RowChildren.add(_messageThumbnail(message));
      RowChildren.add(_messageBody(message));
      RowChildren.add(Text(message.getTime()));
      alignment = MainAxisAlignment.start;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: alignment,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: RowChildren,
        ),
      ),
    );
  }

  Widget _messageThumbnail(ChattingMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Image.asset(
        message.thumbnail,
        width: 50.0,
      ),
    );
  }

  Widget _messageBody(ChattingMessage message) {
    final curUser = _authentication.currentUser;

    bool isSender = false;
    String name = message.name;
    CrossAxisAlignment alignment = CrossAxisAlignment.start;
    EdgeInsets padding = EdgeInsets.only(left: 15.0);

    if (curUser!.uid == message.uid) {
      isSender = true;
      name = "";
      alignment = CrossAxisAlignment.end;
      padding = EdgeInsets.only(right: 15.0);
    }

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Padding(
          padding: padding,
          child: Text(name),
        ),
        ChatBubble(
          comment: message.message,
          isSender: isSender,
        ),
      ],
    );
  }
}