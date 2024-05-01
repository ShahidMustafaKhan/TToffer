import 'package:flutter/material.dart';

internetConnection(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text('Please check your internet connection.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
