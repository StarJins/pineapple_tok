import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pineapple_tok/data/chatting_room.dart';

class ChattingPage extends StatefulWidget {
  final int currentId;
  const ChattingPage(this.currentId, {Key? key}) : super(key: key);

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

  void _loadData() async {
    this.chattingList = await this._loadChattingRoomList();
    setState(() {});
  }

  Future<List<ChattingRoom>> _loadChattingRoomList() async {
    ChattingRoomHandler c = ChattingRoomHandler();
    return c.updateChattingRoomList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }

  List<Widget> _buildChattingRoomList(BuildContext context) {
    if (this.chattingList != null) {
      return List.generate(
        this.chattingList!.length,
        (index) => ListTile(
          leading: Image.asset(this.chattingList![index].picturePath),
          title: Row(
            children: [
              Text(this.chattingList![index].chattingRoomName),
              if (this.chattingList![index].chattingRoomType == ChattingType.group) ... [
                SizedBox(width: 10.0,),
                Text(this.chattingList![index].numOfPeople.toString()),
              ]
            ],
          ),
          subtitle: Text(this.chattingList![index].lastChat),
          trailing: Text(this.chattingList![index].lastTime),
          onTap: () {},
        )
      );
    } else {
      return [ CircularProgressIndicator() ];
    }
  }
}