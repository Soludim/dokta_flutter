import 'dart:convert';
import 'dart:io';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http_parser/http_parser.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../widgets/chat_message.dart';
import 'package:flutter/material.dart';
import '../widgets/image.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  SpeechToText speech = SpeechToText();
  late DialogFlowtter dialogFlowtter;

  bool _isRecording = false;

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);

    ChatMessage botMessage = ChatMessage(
      content: const {
        "text": true,
        "value":
            "Dokta welcomes you 😊. \nWe are here to assist you in all medical issues. \nTo detect for skin scanner, press the camera icon to take a picture or upload an image"
      },
      name: "Bot",
      type: false,
    );

    setState(() {
      _messages.insert(0, botMessage);
    });
    super.initState();
  }

  void record() async {
    setState(() => _isRecording = true);
    bool available = await speech.initialize();
    if (available) {
      await speech.listen(onResult: (SpeechRecognitionResult result) {
        _textController.text = result.recognizedWords;
      });
    } else {
      print("The user has denied the use of speech recognition.");
      stopRecording();
    }
  }

  void stopRecording() {
    speech.stop();
    setState(() => _isRecording = false);
  }

  void _setImage(File image) async {
    ChatMessage message = ChatMessage(
      content: {"text": false, "value": image},
      name: "You",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    // skin cancer api
    Uri skinCancerApi = Uri.parse('https://dokta.herokuapp.com/predict');

    var request = http.MultipartRequest('POST', skinCancerApi);
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType('image', 'jpg')));
    http.StreamedResponse response = await request.send();
    final responseStr = await response.stream.bytesToString();

    getBotResponse(responseStr);
  }

  void handleSubmitted(text) async {
    if (!text.isNotEmpty) return;
    _textController.clear();

    ChatMessage message = ChatMessage(
      content: {"text": true, "value": text},
      name: "You",
      type: true,
    );

    setState(() {
      _messages.insert(0, message);
      speech.stop();
      textValue = "";
      _isRecording = false;
    });

    getBotResponse(text);
  }

  void getBotResponse(text) async {
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)));

    if (response.message == null) return;

    String? fulfillmentText = response.message!.text!.text!.first;
    if (fulfillmentText.isNotEmpty) {
      ChatMessage botMessage = ChatMessage(
        content: {"text": true, "value": fulfillmentText},
        name: "Bot",
        type: false,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    }
  }

  String textValue = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => _messages[index],
        itemCount: _messages.length,
      )),
      const Divider(height: 1.0),
      Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: _textController,
                      onSubmitted: handleSubmitted,
                      onChanged: (value) {
                        setState(() {
                          textValue = value;
                        });
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "Send a message"),
                    ),
                  ),
                  textValue.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () =>
                                handleSubmitted(_textController.text),
                          ),
                        )
                      : ImageInput(_setImage),
                  AvatarGlow(
                    endRadius: 20,
                    animate: _isRecording ? true : false,
                    glowColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      iconSize: 30.0,
                      icon: const Icon(Icons.mic),
                      onPressed: _isRecording ? stopRecording : record,
                    ),
                  )
                ],
              ),
            ),
          )),
    ]);
  }
}
