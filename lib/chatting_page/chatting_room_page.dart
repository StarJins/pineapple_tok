import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pineapple_tok/data/chatting_room.dart';
import 'package:pineapple_tok/data/chatting_comment.dart';
import 'package:pineapple_tok/chatting_page/chat_bubble.dart';

class ChattingRoomPage extends StatefulWidget {
  final ChattingRoom chattingInfo;
  const ChattingRoomPage({Key? key, required this.chattingInfo}) : super(key: key);

  @override
  State<ChattingRoomPage> createState() => _ChattingRoomPageState();
}

class _ChattingRoomPageState extends State<ChattingRoomPage> {
  final _authentication = FirebaseAuth.instance;

  List<ChattingComment>? chattingComments = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._loadData();
  }

  void _loadData() async {
    ChattingCommentHandler handler = ChattingCommentHandler(widget.chattingInfo.id);
    this.chattingComments = await handler.updateChattingComments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Column _buildProfileBody() {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView(
              shrinkWrap: true,
              children: _buildChattingRoom(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChattingRoom(BuildContext context) {
    if (this.chattingComments != null) {
      List<Widget> tileList = List.generate(
          this.chattingComments!.length, (index) =>
          makeChattingCommentWidget(this.chattingComments![index])
      );

      return tileList;
    } else {
      return [ CircularProgressIndicator()];
    }
  }

  Widget makeChattingCommentWidget(ChattingComment comment) {
    final curUser = _authentication.currentUser;

    List<Widget> RowChildren = [];
    MainAxisAlignment alignment = MainAxisAlignment.start;

    if (curUser!.uid == comment.uid) {
      RowChildren.add(Text(comment.time));
      RowChildren.add(_messageBody(comment));
      alignment = MainAxisAlignment.end;
    }
    else {
      RowChildren.add(_messageThumbnail(comment));
      RowChildren.add(_messageBody(comment));
      RowChildren.add(Text(comment.time));
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

  Widget _messageThumbnail(ChattingComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Image.asset(
        comment.thumbnail,
        width: 50.0,
      ),
    );
  }

  Widget _messageBody(ChattingComment comment) {
    final curUser = _authentication.currentUser;

    bool isSender = false;
    String name = comment.name;
    CrossAxisAlignment alignment = CrossAxisAlignment.start;
    EdgeInsets padding = EdgeInsets.only(left: 15.0);

    if (curUser!.uid == comment.uid) {
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
          comment: comment.comment,
          isSender: isSender,
        ),
      ],
    );
  }
}