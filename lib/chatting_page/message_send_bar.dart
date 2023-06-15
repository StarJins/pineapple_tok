import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageSendBar extends StatefulWidget {
  final chattingRoomId;
  const MessageSendBar({Key? key, required this.chattingRoomId}) : super(key: key);

  @override
  State<MessageSendBar> createState() => _MessageSendBarState();
}

class _MessageSendBarState extends State<MessageSendBar> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _textFieldController = TextEditingController();
  var _sendedMessage = '';

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    _firestore
    .collection('chatting').doc('messages')
    .collection('data').doc(widget.chattingRoomId)
    .collection('chat').add({
      'uid' : _authentication.currentUser!.uid,
      'message' : _sendedMessage,
      'time' : Timestamp.now(),
    });
    _textFieldController.clear();
    _sendedMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _sendedMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Colors.yellow,
            onPressed: _sendedMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),),
        ],
      ),
    );
  }
}
