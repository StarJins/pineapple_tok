import 'package:flutter/material.dart';
import 'package:pineapple_tok/data/chatting_room.dart';
import 'package:pineapple_tok/data/chatting_comment.dart';

class ChattingRoomPage extends StatefulWidget {
  final ChattingRoom chattingInfo;
  const ChattingRoomPage({Key? key, required this.chattingInfo}) : super(key: key);

  @override
  State<ChattingRoomPage> createState() => _ChattingRoomPageState();
}

class _ChattingRoomPageState extends State<ChattingRoomPage> {
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
          child: ListView(
            children: _buildChattingRoom(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChattingRoom(BuildContext context) {
    if (this.chattingComments != null) {
      List<Widget> tileList = List.generate(
          this.chattingComments!.length, (index) =>
          makeChattingCommentTile(this.chattingComments![index])
      );

      return tileList;
    } else {
      return [ CircularProgressIndicator()];
    }
  }

  ListTile makeChattingCommentTile(ChattingComment comment) {
    return ListTile(
      leading: Image.asset(comment.thumbnail),
      title: Text(comment.name),
      subtitle: Text(comment.comment),
      trailing: Text(comment.time),
      onTap: () {},
    );
  }
}