import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/src/settings/models/settings_model.dart';

class AppDropdownButtonFormFieldWidget extends StatelessWidget {
  const AppDropdownButtonFormFieldWidget({
    required this.dropdownOptions,
    required this.chosenOption,
    required this.onChanged,
    this.onEditingComplete,
    this.inputFieldController,
    super.key
  });

  final List<DropdownOption> dropdownOptions;
  final DropdownOption chosenOption;
  final TextEditingController? inputFieldController;
  final ValueChanged<String?> onChanged;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        DropdownButtonFormField(
          decoration: InputDecoration(
            border: AppConstants.enabledBorder,
            focusedBorder: AppConstants.focusedBorder
          ),
          dropdownColor: AppColors.kWhite,
          borderRadius: AppConstants.kAppBorderRadius,
          isExpanded: true,
          style: AppTextStyles.defaultStyle,
          value: chosenOption.value,
          items: List.generate(
            dropdownOptions.length,
            (index) {
              return DropdownMenuItem(
                value: dropdownOptions[index].value,
                child: Text(dropdownOptions[index].label)
              );
            }
          ), 
          onChanged: onChanged,
        ),

        // Input field for custom values
        inputFieldController != null
          ? chosenOption.label == "Custom"
            ? AppTextFormFieldWidget(
                controller: inputFieldController!,
                digitsOnly: true,
                onEditingComplete: () {
                  onEditingComplete!();
                  FocusScope.of(context).unfocus();
                },
              )
            : Container()
          : Container()
      ],
    );
  }
}