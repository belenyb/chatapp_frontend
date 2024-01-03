import 'dart:html';

import 'package:flutter/material.dart';

import '../widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isWriting = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios),
              color: theme.colorScheme.primary),
          title: Row(
            children: [
              const CircleAvatar(
                child: Text('Be'),
              ),
              const SizedBox(width: 8),
              Text("Belen Yarde Buller", style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  // shrinkWrap: true,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _messages[index];
                  },
                ),
              ),
              const Divider(height: 1),
              Container(
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _textController,
                          // onSubmitted: (value) => _handleSubmit(value),
                          onChanged: (value) {
                            setState(() {
                              _isWriting = value.trim().isNotEmpty;
                              print(_isWriting);
                            });
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Escribir...'),
                          focusNode: _focusNode,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: theme.colorScheme.primary),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: _isWriting
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null,
                            icon: const Icon(Icons.send),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleSubmit(String value) {
    if (value.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: value,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose > off socket
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
