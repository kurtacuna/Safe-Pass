import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';

class VisitorHeaderWidget extends StatelessWidget {
  const VisitorHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<SidebarNotifier>().setIndex = 2;
            context.read<SettingsTabNotifier>().setTabIndex = 1;
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Visitor Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 