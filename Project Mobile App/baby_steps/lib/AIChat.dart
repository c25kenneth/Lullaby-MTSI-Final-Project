import 'package:baby_steps/HuggingFaceAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import 'package:huggingface_dart/huggingface_dart.dart';

HfInference hfInference = HfInference('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');

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  
  final _bot = const types.User(
    id: 'bot',
  );

  void _addMessage(types.Message message) {
    if (this.mounted) {
      setState(() {
        _messages.insert(0, message);
      });
    }
  }


  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    final data = await query(message.text);

    final botMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: data[0]["generated_text"],
    );

    _addMessage(botMessage);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Lully!"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
            ),
          ),
        ],
      ),
    );
  }
}