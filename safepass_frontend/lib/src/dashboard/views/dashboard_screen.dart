import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Note to developer:
  // When developing, change the value of _index in the sidebar_notifier.dart file
  // found at ./entrypoint/controllers/sidebar_notifier.dart
  // Do this so that every time Flutter hot restarts, it goes to your screen
  
  // Change _index to 0 after you're done developing your part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Dashboard"))
    );
  }
}