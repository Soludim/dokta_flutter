import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {Key? key, required this.content, required this.name, required this.type})
      : super(key: key);

  final Map<String, dynamic> content;
  final String name;
  final bool type;

  Widget otherMessage(context) {
    SpinKitThreeBounce spinkit = SpinKitThreeBounce(
      color: Theme.of(context).primaryColor,
      size: 16.0,
    );

    return Bubble(
        margin: const BubbleEdges.only(top: 10),
        alignment: Alignment.topLeft,
        nipWidth: 8,
        nipHeight: 24,
        nip: BubbleNip.leftTop,
        child: content["text"]
            ? Text(content["value"])
            : SizedBox(width: 100, child: spinkit));
  }

  Widget myMessage(context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nipWidth: 8,
      nipHeight: 24,
      nip: BubbleNip.rightTop,
      color: const Color.fromRGBO(225, 255, 199, 1.0),
      child: content["text"]
          ? Text(content["value"], textAlign: TextAlign.right)
          : Image.file(
              content["value"],
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
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
