import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _lastVisitController = TextEditingController();
  final _visitPurposeController = TextEditingController();
  final _checkOutTimeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    _lastVisitController.dispose();
    _visitPurposeController.dispose();
    _checkOutTimeController.dispose();
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
                            width: 400,
                            child: AppTextFormFieldWidget(
                              controller: _nameController,
                              hintText: 'Name',
                              validatorText: 'Please enter visitor name',
                              //enabled: false,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400,
                            child: AppTextFormFieldWidget(
                              controller: _idNumberController,
                              hintText: 'ID Number',
                              validatorText: 'Please enter ID number',
                              //enabled: false,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400,
                            child: AppTextFormFieldWidget(
                              controller: _lastVisitController,
                              hintText: 'Last Visit',
                              validatorText: 'Please enter last visit date',
                              //enabled: false,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400,
                            child: AppTextFormFieldWidget(
                              controller: _visitPurposeController,
                              hintText: 'Visit Purpose',
                              validatorText: 'Please enter visit purpose',
                              //enabled: false,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 400,
                            child: AppTextFormFieldWidget(
                              controller: _checkOutTimeController,
                              hintText: 'Check-Out Time',
                              validatorText: 'Please enter check-out time',
                              //enabled: false,
                            ),
                          ),
                          const SizedBox(height: 30),
                          AppButtonWidget(
                            width: 400,
                            onTap: () {
                              // TODO: Implement confirm check-out
                            },
                            text: 'Confirm Check-Out',
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
                          'Visitor Check-Out',
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: AppColors.kDarkGray,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AppButtonWidget(
                                  width: 400,
                                  onTap: () {
                                    // Button is just for display in this case
                                  },
                                  text: 'FACE RECOGNIZED',
                                  color: AppColors.kLightGreen,
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