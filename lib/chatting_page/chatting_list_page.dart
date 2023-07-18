import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pineapple_tok/data/chatting_room.dart';
import 'package:pineapple_tok/chatting_page/chatting_room_page.dart';
import 'package:pineapple_tok/chatting_page/new_chatting_page.dart';

class ChattingPage extends StatefulWidget {
  static List<Widget> chattingList = [];

  const ChattingPage({Key? key}) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  List<ChattingRoom>? chattingList = null;

  // initState는 statefulWidget이 생성될 때 제일 처음에 호출된다.
  // initState와 반대의 개념인 deactivate도 존재한다.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initState가 끝나기 전에 build가 호출될 수 있다.
    // 따라서 변수가 초기화 되기 전에 build가 실행될 수 있는 것
    // 이전 version에서는 FutureBuilder를 통해 이를 제어
    // 현재 version에서는 if문과 null을 통해 이를 제어
    // 변수 초기화 후 widget을 rebuild하기 위해 loadData 내에서 setState 호출
    this._loadData();
  }

  Future<void> _loadData() async {
    this.chattingList = await this._loadChattingRoomList();
    setState(() {});
  }

  Future<List<ChattingRoom>?> _loadChattingRoomList() async {
    ChattingRoomHandler c = ChattingRoomHandler();
    return c.updateChattingRoomList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chatting page'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () async {
                dynamic result = await Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: NewChattingPage(),
                  ),
                );

                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('채팅방 생성 성공'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.lightBlue,
                    ),
                  );
                }

                await this._loadData();
              },
              icon: Icon(Icons.add_box),
              splashRadius: 20.0,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _buildChattingRoomList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChattingRoomList(BuildContext context) {
    if (this.chattingList != null) {
      this.chattingList!.sort((a, b) => b.lastChatTime.compareTo(a.lastChatTime));
      ChattingPage.chattingList = List.generate(this.chattingList!.length, (index) => ListTile(
        leading: Image.asset(this.chattingList![index].thumbnail),
        title: Row(
          children: [
            Text(this.chattingList![index].chattingRoomName),
            if (this.chattingList![index].chattingRoomType == ChattingType.group) ... [
              SizedBox(width: 5.0,),
              Text(this.chattingList![index].numOfPeople.toString()),
            ]
          ],
        ),
        subtitle: Text(this.chattingList![index].lastChat),
        trailing: Text(this.chattingList![index].getStrTimeToPrint()),
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ChattingRoomPage(
                chattingInfo: this.chattingList![index],
              ),
            ),
          ).then((value) {
            this._loadData();
          });
        },
      ));

      ChattingPage.chattingList.insert(0, Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(
          '채팅: ${this.chattingList!.length}',
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ));
    }

     return ChattingPage.chattingList;
  }
}