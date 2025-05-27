import 'package:flutter/material.dart';

SnackBar appErrorSnackBarWidget({
  required BuildContext context,
  required String text,
}) {
  return SnackBar(
    content: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
  );
} 