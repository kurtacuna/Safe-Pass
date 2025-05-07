import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';

class AppConstants {
  static EdgeInsets get kAppPadding => EdgeInsets.all(50);
  static BorderRadius get kAppBorderRadius => BorderRadius.circular(5);
  static List<BoxShadow> get kAppBoxShadow => <BoxShadow>[
    BoxShadow(
      blurRadius: 10,
      color: const Color.fromARGB(255, 221, 216, 216),
    )
  ];
  
  static OutlineInputBorder get enabledBorder => OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.kGray
    )
  );
  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.kDarkBlue,
      width: 2,
    )
  );
  static OutlineInputBorder get errorBorder => OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.kDarkRed,
      width: 2,
    ),
  );
}