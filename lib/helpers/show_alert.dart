import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String title, String subtitle, void Function()? action, {bool? showCancelBtn = false}) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          MaterialButton(
            onPressed: action,
            child: const Text("Accept"),
          ),
          if(showCancelBtn == true) MaterialButton(onPressed: () => Navigator.pop(context), child: const Text("Accept"))
        ],
      ),
    );
  }

  showCupertinoDialog(
    context: context,
    builder: ( _ ) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        CupertinoDialogAction(
          onPressed: action,
          child: const Text("Accept"),
        ),
        if(showCancelBtn == true) CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.pop(context), child: const Text("Cancel"))
      ],
    )
  );
}
