import 'package:flutter/material.dart';

class VisitorActionButtons extends StatelessWidget {
  const VisitorActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          label: 'Update',
          icon: Image.asset(
            'assets/images/update_icon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            // Update functionality will be added later
          },
        ),
        const SizedBox(width: 16),
        _ActionButton(
          label: 'Archive',
          icon: Image.asset(
            'assets/images/archive_icon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            // Archive functionality will be added later
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 