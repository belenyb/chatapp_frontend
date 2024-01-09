import 'package:chat_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
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
    final ChatService chatService = Provider.of<ChatService>(context);
    final User userTo = chatService.userTo;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
            color: theme.colorScheme.primary),
        title: Row(
          children: [
            CircleAvatar(
              child: Text(userTo.name.substring(0, 2)),
            ),
            const SizedBox(width: 8),
            Text(userTo.name, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Flexible(
                child: Container(
                  color: const Color(0xffF2F2F2),
                  child: ListView.builder(
                    // shrinkWrap: true,
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _messages[index];
                    },
                  ),
                ),
              ),
              const Divider(height: 1.5),
              Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(5, 0, 0, 0),
                      offset: Offset(0, -12),
                      blurRadius: 24)
                ]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _textController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) =>
                                _handleSubmit(_textController.text.trim()),
                            minLines: 1,
                            maxLines: 3,
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
