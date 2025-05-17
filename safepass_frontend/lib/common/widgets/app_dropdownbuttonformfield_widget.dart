import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';

class AppDropdownbuttonformfieldWidget extends StatelessWidget {
  const AppDropdownbuttonformfieldWidget({
    required this.value,
    required this.dropdownValues,
    required this.onChanged,
    super.key
  });
  
  final String value;
  final List<String> dropdownValues;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: AppConstants.enabledBorder,
        focusedBorder: AppConstants.focusedBorder
      ),
      style: AppTextStyles.defaultStyle,
      value: value,
      items: List.generate(
        dropdownValues.length,
        (index) {
          return DropdownMenuItem(
            value: dropdownValues[index],
            child: Text(dropdownValues[index])
          );
        }
      ), 
      onChanged: onChanged
    );
  }
}