import 'package:flutter/material.dart';
import 'package:safepass_frontend/src/dashboard/models/visitor_log_model.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class VisitorLogRow extends StatelessWidget {
  final VisitorLog log;

  const VisitorLogRow({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _DataText(log.name),
          _DataText(log.checkIn),
          _DataText(log.checkOut == "-" ? "" : log.checkOut),
          _DataText('01/01/2001'), // Replace if real date field is added
          _DataText(log.purpose),
          _StatusTag(log.status),
        ],
      ),
    );
  }
}

class _DataText extends StatelessWidget {
  final String text;
  const _DataText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.defaultStyle.copyWith(color: Colors.black54),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String status;
  const _StatusTag(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'checked-in':
        color = AppColors.kLightGreen;
        break;
      case 'checked-out':
        color = AppColors.kDarkBlue;
        break;
      case 'denied':
        color = AppColors.kLightRed;
        break;
      default:
        color = AppColors.kGray;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status,
          style: AppTextStyles.smallStyle.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
