import "package:flutter/material.dart";
import 'dart:math' as math;

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-15, 5);
    path.lineTo(-10, 15);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ChatBubble extends StatelessWidget {
  final String comment;
  final bool isSender;
  const ChatBubble({Key? key, required this.comment, required this.isSender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    BorderRadius borderRadius = BorderRadius.only(
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    );
    EdgeInsets margin = EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0);

    if (this.isSender) {
      color = Colors.yellow;
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
      margin = EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0);
    }

    Widget messageBody = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text(
        comment,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    List<Widget> messageList = [];

    if (isSender) {
      messageList.add(messageBody);
      messageList.add(CustomPaint(painter: Triangle(color),));
    }
    else {
      messageList.add(SizedBox(width: 5.0,));
      messageList.add(
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: Triangle(color),
          ),
        )
      );
      messageList.add(messageBody);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: messageList,
    );
  }
}
