import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class AppCircularProgressIndicatorWidget extends StatelessWidget {
  const AppCircularProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: AppColors.kDarkBlue,
      valueColor: AlwaysStoppedAnimation(
        AppColors.kWhite
      )
    );
  }
}