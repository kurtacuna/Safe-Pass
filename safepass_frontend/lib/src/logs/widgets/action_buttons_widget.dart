import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import '../../visitor/screens/visitor_details_screen.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  const ActionButtonsWidget({
    super.key,
    required this.onEdit,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ClickableIcon(
          assetPath: 'assets/images/edit_icon.png',
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const VisitorDetailsScreen(),
            //   ),
            // );
            // onEdit();
            context.read<SidebarNotifier>().setIndex = 3;
          },
        ),
        const SizedBox(width: 8),
        _ClickableIcon(
          assetPath: 'assets/images/archive_icon.png',
          onTap: onArchive,
        ),
      ],
    );
  }
}

class _ClickableIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _ClickableIcon({
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Increases tap target slightly
          child: Image.asset(
            assetPath,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
