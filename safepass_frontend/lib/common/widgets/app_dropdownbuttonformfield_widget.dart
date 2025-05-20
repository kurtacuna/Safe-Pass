import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/src/settings/models/settings_model.dart';

class AppDropdownButtonFormFieldWidget extends StatefulWidget {
  AppDropdownButtonFormFieldWidget({
    required this.dropdownOptions,
    required this.chosenOption,
    this.inputFieldController,
    super.key
  });

  final List<dynamic> dropdownOptions;
  dynamic chosenOption;
  final TextEditingController? inputFieldController;

  @override
  State<AppDropdownButtonFormFieldWidget> createState() => _AppDropdownButtonFormFieldWidgetState();
}

class _AppDropdownButtonFormFieldWidgetState extends State<AppDropdownButtonFormFieldWidget> {
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
          value: widget.chosenOption.value,
          items: List.generate(
            widget.dropdownOptions.length,
            (index) {
              return DropdownMenuItem(
                value: widget.dropdownOptions[index].value,
                child: Text(widget.dropdownOptions[index].label)
              );
            }
          ), 
          onChanged: (value) {
            setState(() {
              widget.chosenOption = widget.dropdownOptions.firstWhere((element) => element.value == value);
            });
          }
        ),

        // Input field for custom values
        widget.inputFieldController != null
          ? widget.chosenOption.label == "Custom"
            ? AppTextFormFieldWidget(
                controller: widget.inputFieldController!,
                digitsOnly: true,
                onEditingComplete: () {
                  setState(() {
                    widget.chosenOption = widget.dropdownOptions.firstWhere(
                      (element) => element.value == widget.inputFieldController!.text,
                      orElse:() {
                        DropdownOption customOption = widget.chosenOption;
                        customOption.value = widget.inputFieldController!.text;
                        return customOption;
                      }
                    );
                  });
                  FocusScope.of(context).unfocus();
                },
              )
            : Container()
          : Container()
      ],
    );
  }
}