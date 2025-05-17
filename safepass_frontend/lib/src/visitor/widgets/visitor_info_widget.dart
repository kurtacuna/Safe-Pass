import 'package:flutter/material.dart';

class VisitorInfoWidget extends StatelessWidget {
  const VisitorInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoField('Name', 'John Manalo'),
        const SizedBox(height: 16),
        _buildInfoField('ID Number', '2024-787'),
        const SizedBox(height: 16),
        _buildInfoField('Status', 'Approved'),
        const SizedBox(height: 16),
        _buildInfoField('Last Visit', '01-04-2024'),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
} 