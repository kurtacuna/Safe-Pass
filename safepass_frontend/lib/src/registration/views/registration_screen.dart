import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  String? _selectedIdType;
  String? _selectedVisitPurpose;

  final List<String> _idTypes = [
    'Drivers License',
    'Passport',
    'National ID',
    'Government-Issued ID',
    'Professional Identification Card (PIC)',
    'Postal ID',
    'School ID',
    'Company/Corporate ID',
    'Other'
  ];
  final List<String> _visitPurposes = [
    'Family Visit',
    'Legal Visit',
    'Official Visit',
    'Religious Visit/Pastoral Counseling',
    'Educational/Rehabilitative Program Visit',
    'Media Visit',
    'Other'
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Back to Dashboard Button
          Positioned(
            top: 50,
            right: 50,
            child: TextButton.icon(
              onPressed: () => context.go('/entrypoint'),
              icon: Icon(Icons.arrow_back, color: AppColors.kDarkBlue),
              label: Text(
                'Back to Dashboard',
                style: AppTextStyles.bigStyle.copyWith(
                  color: AppColors.kDarkBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          // Logo
          Positioned(
            top: 50,
            left: 50,
            child: Image.asset(
              AppImages.logoDark,
              height: 50,
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Visitor Details Form
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120.0, left: 300),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Visitor\'s Details',
                            style: AppTextStyles.biggestStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.kDark,
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: 400, // Reduced width
                            child: AppTextFormFieldWidget(
                              controller: _firstNameController,
                              hintText: 'Enter your first name',
                              validatorText: 'Please enter your first name',
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400, // Reduced width
                            child: AppTextFormFieldWidget(
                              controller: _middleNameController,
                              hintText: 'Enter your middle name',
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400, // Reduced width
                            child: AppTextFormFieldWidget(
                              controller: _lastNameController,
                              hintText: 'Enter your last name',
                              validatorText: 'Please enter your last name',
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.kLighterGray,
                              borderRadius: AppConstants.kAppBorderRadius,
                              border: Border.all(color: AppColors.kGray),
                            ),
                            width: 400, // Reduced width for dropdown
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                value: _selectedIdType,
                                hint: Text('ID Type'),
                                style: AppTextStyles.defaultStyle,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                ),
                                items: _idTypes.map((String type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdType = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400, // Reduced width
                            child: AppTextFormFieldWidget(
                              controller: _idNumberController,
                              hintText: 'Enter your ID Number',
                              validatorText: 'Please enter your ID number',
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.kLighterGray,
                              borderRadius: AppConstants.kAppBorderRadius,
                              border: Border.all(color: AppColors.kGray),
                            ),
                            width: 400, // Reduced width for dropdown
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                value: _selectedVisitPurpose,
                                hint: Text('Visit Purpose'),
                                style: AppTextStyles.defaultStyle,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                ),
                                items: _visitPurposes.map((String purpose) {
                                  return DropdownMenuItem(
                                    value: purpose,
                                    child: Text(purpose),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedVisitPurpose = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30), // Add spacing before the button
                          AppButtonWidget(
                            width: 400,
                            onTap: () {
                              // TODO: Implement face scanning from this button
                            },
                            text: 'Enter Visitor',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                // Right side - Face Recognition
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0, right: 350.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Visitor Registration',
                          style: AppTextStyles.biggestStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.kDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Facial Recognition',
                          style: AppTextStyles.biggerStyle.copyWith(
                            color: AppColors.kDarkGray,
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppContainerWidget(
                          width: double.infinity,
                          height: 500,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 400,
                                  height: 350,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: AppConstants.kAppBorderRadius,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: AppColors.kDarkGray,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AppButtonWidget(
                                  width: 400,
                                  onTap: () {
                                    // TODO: Implement face scanning
                                  },
                                  text: 'SCAN FACE',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}