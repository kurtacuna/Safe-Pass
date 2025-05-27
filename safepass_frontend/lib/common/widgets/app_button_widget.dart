import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

// Custom button widget with predefeind color and tex style
class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    required this.onTap,
    this.child,
    this.text,
    this.width,
    this.height,
    this.color,
    this.isLoading = false,
    super.key
  });

  // The function to execute on tap
  final void Function()? onTap;
  
  // A widget in place for the text at the center of the button
  // If provided, this will be displayed instead of text
  final Widget? child;

  // The text at the center of the button
  // This is not displayed if child is provided
  final String? text;

  // Width of the button
  // Default value is 340
  final double? width;

  // Height of the button
  // Default value is 48
  final double? height;

  // Color of the button
  // Default value is kDarkBlue
  final Color? color;

  // Whether the button is in loading state
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: AppConstants.kAppBorderRadius,
        child: Ink(
          width: width ?? 340,
          height: height ?? 48,
          decoration: BoxDecoration(
            color: (isLoading || onTap == null) ? AppColors.kGray : (color ?? AppColors.kDarkBlue),
            borderRadius: AppConstants.kAppBorderRadius
          ),
          child: Center(
            child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
                  ),
                )
              : (child ?? Text(
                  text ?? "Add a text",
                  style: AppTextStyles.bigStyle.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.kWhite,
                  )
                )),
          )
        )
      )
    );
  }
}