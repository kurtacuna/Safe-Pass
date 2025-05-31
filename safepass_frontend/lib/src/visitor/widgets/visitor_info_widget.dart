import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kglobal_keys.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart';
import 'package:safepass_frontend/common/widgets/app_dropdownbuttonformfield_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/src/registration/controller/id_types_controller.dart';
import 'package:safepass_frontend/src/registration/models/id_types_model.dart';
import 'package:safepass_frontend/src/settings/models/settings_model.dart';
import 'package:safepass_frontend/src/settings/models/visitor_details_model.dart';
import 'package:safepass_frontend/src/visitor/controllers/visitor_details_controller.dart';

class VisitorInfoWidget extends StatefulWidget {
  const VisitorInfoWidget({
    required this.visitor,
    super.key
  });

  final Visitor? visitor;

  @override
  State<VisitorInfoWidget> createState() => _VisitorInfoWidgetState();
}

class _VisitorInfoWidgetState extends State<VisitorInfoWidget> {
  GlobalKey<FormState> formKey = AppGlobalKeys.editVisitorDetails;
  List<DropdownOption> idTypes = [];
  List<DropdownOption> status = [
    DropdownOption(
      label: 'Approved', 
      value: 'Approved'
    ),
    DropdownOption(
      label: 'Archived', 
      value: 'Archived'
    ),
    DropdownOption(
      label: 'Blacklisted', 
      value: 'Blacklisted'
    ),
  ];
  

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IdTypesController>().fetchIdTypes(context);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController(
        text: widget.visitor!.firstName
    );
    TextEditingController middleNameController = TextEditingController(
        text: widget.visitor!.middleName
    );
    TextEditingController lastNameController = TextEditingController(
        text: widget.visitor!.lastName
    );
    TextEditingController contactNumberController = TextEditingController(
        text: widget.visitor!.contactNumber
    );
    TextEditingController idTypeController = TextEditingController(
        text: widget.visitor!.idType.type
    );
    TextEditingController idNumberController = TextEditingController(
        text: widget.visitor!.idNumber.split('-')[1]
    );
    TextEditingController statusController = TextEditingController(
        text: widget.visitor!.status
    );
    TextEditingController regDateController = TextEditingController(
        text: DateFormat('MMM d, y H:m').format(widget.visitor!.registrationDate)
    );

    if (context.watch<IdTypesController>().getIsLoading) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    idTypes = context.read<IdTypesController>().getIdTypes.map((e) => DropdownOption(label: e.type, value: e.type)).toList();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoField(
            label: 'First Name',
            controller: firstNameController,
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'Middle Name', 
            controller: middleNameController
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'Last Name', 
            controller: lastNameController
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'Contact Number',
            controller: contactNumberController,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'ID Type',
            dropdownOptions: idTypes,
            chosenOption: idTypes.firstWhere((e) => e.label == widget.visitor!.idType.type),
            onChanged: (selectedOption) {
              idTypeController.text = selectedOption!;
            }
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'ID Number', 
            controller: idNumberController
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Status', 
            dropdownOptions: status, 
            chosenOption: status.firstWhere((e) => e.label == widget.visitor!.status), 
            onChanged: (selectedOption) {
              statusController.text = selectedOption!;
            }
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'Registration Date',
            controller: regDateController,
            enabled: false
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: context.watch<VisitorDetailsController>().getIsLoading
              ? Center(child: AppCircularProgressIndicatorWidget())
              : AppButtonWidget(
                  text: 'Save',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      context.read<VisitorDetailsController>().updateVisitorDetails(
                        context: context, 
                        id: widget.visitor!.id.toString(), 
                        firstName: firstNameController.text, 
                        middleName: middleNameController.text, 
                        lastName: lastNameController.text, 
                        contactNumber: contactNumberController.text, 
                        idType: idTypeController.text, 
                        idNumber: idNumberController.text,
                        status: statusController.text
                      );
                    }
                  }
                )
          )
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        AppTextFormFieldWidget(
          controller: controller,
          enabled: enabled,
        )
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<DropdownOption> dropdownOptions,
    required DropdownOption chosenOption,
    required Function(String?) onChanged
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        AppDropdownButtonFormFieldWidget(
          dropdownOptions: dropdownOptions, 
          chosenOption: chosenOption, 
          onChanged: onChanged
        )
      ],
    );
  }
} 