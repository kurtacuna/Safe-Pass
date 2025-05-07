import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';

class AppStatCardWidget extends StatelessWidget {
  final String count;
  final String label;
  final String totalIconPath;  
  final String bottomIconPath; 

  const AppStatCardWidget({
    super.key,
    required this.count,
    required this.label,
    required this.totalIconPath,
    required this.bottomIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 208,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: AppConstants.kAppBorderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 238, 232, 232),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            count,
            style: AppTextStyles.bigStyle.copyWith(
              fontSize: 48,
              color: AppColors.kDarkGray,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                totalIconPath,
                width: 16,
                height: 16,
                color: AppColors.kDarkGray,
              ),
              const SizedBox(width: 6),
              Text(
                "Total",
                style: AppTextStyles.defaultStyle.copyWith(
                  color: AppColors.kDarkGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    bottomIconPath,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: AppTextStyles.defaultStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.kDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
