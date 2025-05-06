import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

// Custom TextButton widget with a RoundedRectangularBorder for the splash
class AppTextButtonWidget extends StatelessWidget {
  const AppTextButtonWidget({
    required this.onPressed,
    required this.child,
    super.key
  });

  // The function to run when pressed
  final void Function() onPressed;

  // The widget inside the button
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: AppConstants.kAppBorderRadius
        ),
        overlayColor: Theme.of(context).splashColor
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}