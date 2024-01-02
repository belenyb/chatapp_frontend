import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/images/logo.png'),
            height: 180,
          ),
          const SizedBox(height: 8),
          Text("QuickMessage", style: Theme.of(context).textTheme.headline6)
        ],
      ),
    );
  }
}
