import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';

class AppAdminProfile extends StatelessWidget {
  final String name;
  final String imagePath;

  const AppAdminProfile({
    super.key,
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.defaultStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.kDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Admin account',
              style: AppTextStyles.defaultStyle.copyWith(
                fontSize: 13,
                color: AppColors.kGray
              ),
            ),
          ],
        ),
      ],
    );
  }
}
