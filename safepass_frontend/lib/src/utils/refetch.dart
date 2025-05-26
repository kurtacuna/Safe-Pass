import 'package:flutter/material.dart';

Future<void> refetch({
  required Future<void> Function() fetch,
}) async {
  try {
    // Here you would typically refresh the token first
    // For now, we'll just retry the fetch
    await fetch();
  } catch (e) {
    debugPrint('Error in refetch: $e');
  }
} 