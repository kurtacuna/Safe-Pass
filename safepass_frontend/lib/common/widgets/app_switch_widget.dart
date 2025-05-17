import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class AppSwitchWidget extends StatelessWidget {
  const AppSwitchWidget({
    required this.value,
    required this.onChanged,
    this.scale = 0.8,
    super.key
  });
  
  final bool value;
  final void Function(bool) onChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Switch(
        value: value,
        onChanged: onChanged,
        trackOutlineWidth: WidgetStatePropertyAll(3),
        trackOutlineColor: WidgetStatePropertyAll(AppColors.kDarkBlue),
        thumbColor: value == true
          ? WidgetStatePropertyAll(AppColors.kWhite)
          : WidgetStatePropertyAll(AppColors.kDarkBlue),
        activeTrackColor: AppColors.kDarkBlue,
        inactiveTrackColor: AppColors.kWhite,
      ),
    );
  }
}