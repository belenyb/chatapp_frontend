import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("No tenes cuenta?"),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, 'register'),
          child: const Text(
            "Registrate",
          ),
        ),
      ],
    );
  }
}
