import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;
  const ChatMessage(
      {Key? key,
      required this.text,
      required this.uid,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        child: Container(
          child: uid == '123' ? _ownMessage(theme) : _foreignMessage(theme),
        ),
      ),
    );
  }

  Widget _ownMessage(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8, right: 8, left: 50),
        decoration: const BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(text,
            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _foreignMessage(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8, left: 8, right: 50),
        decoration: const BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
