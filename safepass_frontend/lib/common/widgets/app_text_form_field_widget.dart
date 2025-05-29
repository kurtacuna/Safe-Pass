import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

// Custom TextFormField with attributes that should be consistent across all TextFormField widgets
class AppTextFormFieldWidget extends StatelessWidget {
  const AppTextFormFieldWidget({
    required this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.validatorText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.digitsOnly = false,
    this.inputFormatters,
    this.keyboardType,
    this.enabled = true,
    this.style,
    this.onChanged,
    super.key
  });

  // Controller for the value inside the field
  final TextEditingController controller;

  // Used to programmatically set the focus to this field
  final FocusNode? focusNode;

  // A function that executes when the user changes focus from this field
  final void Function()? onEditingComplete;

  // The text that appears if the field doesn't meet the specified requirements
  final String? validatorText;

  // The placeholder text
  final String? hintText;

  // The icon on the left of the field
  final Widget? prefixIcon;

  // The icon on the right of the field
  final Widget? suffixIcon;

  // A flag to set if the text inside the field is obscured
  final bool obscureText;

  // Determine if input field is digits only
  final bool digitsOnly;

  // Custom input formatters
  final List<TextInputFormatter>? inputFormatters;

  // The type of keyboard to use for editing the text
  final TextInputType? keyboardType;

  // Whether the text field is enabled
  final bool enabled;

  // Custom text style
  final TextStyle? style;

  // Called when the text changes
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      inputFormatters: digitsOnly == true
        ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
        : inputFormatters,
      obscureText: obscureText ? true : false,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType ?? TextInputType.text,
      onEditingComplete: onEditingComplete,
      onTapOutside: onEditingComplete != null
        ? (event) => onEditingComplete!()
        : null,
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return validatorText ?? "Please enter a valid input";
        } else {
          return null;
        }
      },
      style: style ?? (enabled 
        ? AppTextStyles.defaultStyle
        : AppTextStyles.defaultStyle.copyWith(color: AppColors.kDark)),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? SizedBox(width: 20, height: 20, child: prefixIcon)
            : null,
        suffixIcon: suffixIcon != null
            ? SizedBox(width: 20, height: 20, child: suffixIcon)
            : null,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        filled: true,
        fillColor: enabled ? AppColors.kLighterGray : const Color(0xFFFAF7F7),
        enabledBorder: AppConstants.enabledBorder,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        border: InputBorder.none,
      ),
    );
  }
}