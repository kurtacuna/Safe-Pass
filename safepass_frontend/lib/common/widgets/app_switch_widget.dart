import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class AppSwitchWidget extends StatefulWidget {
  AppSwitchWidget({
    required this.value,
    this.scale = 0.8,
    super.key
  });
  
  bool value;
  final double scale;

  @override
  State<AppSwitchWidget> createState() => _AppSwitchWidgetState();
}

class _AppSwitchWidgetState extends State<AppSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: Switch(
        value: widget.value,
        onChanged: (value) {
          setState(() {
            widget.value = value;
          });
        },
        trackOutlineWidth: WidgetStatePropertyAll(3),
        trackOutlineColor: WidgetStatePropertyAll(AppColors.kDarkBlue),
        thumbColor: widget.value == true
          ? WidgetStatePropertyAll(AppColors.kWhite)
          : WidgetStatePropertyAll(AppColors.kDarkBlue),
        activeTrackColor: AppColors.kDarkBlue,
        inactiveTrackColor: AppColors.kWhite,
      ),
    );
  }
}