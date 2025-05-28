import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safepass_frontend/src/settings/models/visitor_details_model.dart';

class VisitorInfoWidget extends StatelessWidget {
  const VisitorInfoWidget({
    required this.visitor,
    super.key
  });

  final Visitor? visitor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoField('Name', visitor!.fullName),
        const SizedBox(height: 16),
        _buildInfoField('ID Number', visitor!.idNumber),
        const SizedBox(height: 16),
        _buildInfoField('Status', visitor!.status),
        const SizedBox(height: 16),
        _buildInfoField('Registration Date', DateFormat('MMM d, y H:m').format(visitor!.registrationDate)),
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