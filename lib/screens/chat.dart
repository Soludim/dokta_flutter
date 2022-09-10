import 'dart:convert';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../widgets/chat_message.dart';
import 'package:flutter/material.dart';

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
    DialogFlowtter.fromFile().then((instance) =>dialogFlowtter = instance);
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

  void handleSubmitted(text) async {
    if (!text.isNotEmpty) return;
    _textController.clear();

    ChatMessage message = ChatMessage(
      text: text,
      name: "You",
      type: true,
    );

    setState(() {
      _messages.insert(0, message);
      speech.stop();
      _isRecording = false;
    });

    // http.Response response = await http.post(
    //     Uri.parse('https://dokta.herokuapp.com/bot'),
    //     body: {"query": text});
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));

    if (response.message == null) return;
    print(response.message!.text!.text!.first);
    String? fulfillmentText = response.message!.text!.text!.first;//json.decode(response.body)["data"];
    if (fulfillmentText.isNotEmpty) {
      ChatMessage botMessage = ChatMessage(
        text: fulfillmentText,
        name: "Bot",
        type: false,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    }
  }

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
                      decoration: const InputDecoration.collapsed(
                          hintText: "Send a message"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => handleSubmitted(_textController.text),
                    ),
                  ),
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
