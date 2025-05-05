import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

// Custom container with predefined box shadow and border radius
class AppContainerWidget extends StatelessWidget {
  const AppContainerWidget({
    required this.width,
    required this.height,
    required this.child,
    this.boxShadow,
    super.key
  });

  // Width of the container
  final double width;

  // Height of the container
  final double height;

  // The widget inside the container
  final Widget child;

  // An optional box shadow to override the default box shadow
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: AppConstants.kAppBorderRadius,
        boxShadow: boxShadow ?? AppConstants.kAppBoxShadow
      ),
      child: child
    );
  }
}