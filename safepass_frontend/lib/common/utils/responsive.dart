import 'package:flutter/material.dart';

class AppResponsive {
  final BuildContext context;
  const AppResponsive(this.context);

  dynamic responsiveWidget(
    {
      required Widget small,
      required Widget large,
      double thresholdWidth = 800,
    }
  ) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth < thresholdWidth) {
      return small;
    } else {
      return large;
    }
  }
}