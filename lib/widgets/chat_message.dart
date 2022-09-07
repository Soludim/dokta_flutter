import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.name, required this.type});

  final String text;
  final String name;
  final bool type;

  Widget otherMessage(context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nipWidth: 8,
      nipHeight: 24,
      nip: BubbleNip.leftTop,
      child: Text(text),
    );
  }

  Widget myMessage(context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nipWidth: 8,
      nipHeight: 24,
      nip: BubbleNip.rightTop,
      color: const Color.fromRGBO(225, 255, 199, 1.0),
      child: Text(text, textAlign: TextAlign.right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: type ? myMessage(context) : otherMessage(context),
    );
  }
}
