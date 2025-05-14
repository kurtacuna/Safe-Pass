import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _lastVisitController = TextEditingController();
  String? _selectedVisitPurpose;
  final _checkInTimeController = TextEditingController();
  String? _selectedStatus;

  final List<String> _visitPurposes = [
    'Legal Consultation',
    'Family Visit',
    'Official Visit',
    'Religious Visit/Pastoral Counseling',
    'Educational/Rehabilitative Program Visit',
    'Media Visit',
    'Other'
  ];

  final List<String> _statuses = [
    'Approved',
    'Pending',
    'Rejected'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    _lastVisitController.dispose();
    _checkInTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
                      padding: EdgeInsets.only(top: 120.0, left: screenWidth * 0.1),
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
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 400,
                              child: AppTextFormFieldWidget(
                                controller: _idNumberController,
                                hintText: 'ID Number',
                                validatorText: 'Please enter ID number',
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 400,
                              child: AppTextFormFieldWidget(
                                controller: _lastVisitController,
                                hintText: 'Last Visit',
                                validatorText: 'Please enter last visit date',
                                //enabled: false, // Since this will be auto-filled when face is recognized
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kLighterGray,
                                borderRadius: AppConstants.kAppBorderRadius,
                                border: Border.all(color: AppColors.kGray),
                              ),
                              width: 400,
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
                            const SizedBox(height: 30),
                            Text(
                              'Status',
                              style: AppTextStyles.bigStyle.copyWith(
                                color: AppColors.kDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kLighterGray,
                                borderRadius: AppConstants.kAppBorderRadius,
                                border: Border.all(color: AppColors.kGray),
                              ),
                              width: 400,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  hint: Text('Status'),
                                  style: AppTextStyles.defaultStyle,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                  items: _statuses.map((String status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedStatus = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 400,
                              child: AppTextFormFieldWidget(
                                controller: _checkInTimeController,
                                hintText: 'Check-In Time',
                                validatorText: 'Please enter check-in time',
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButtonWidget(
                                  width: 190,
                                  onTap: () {
                                    // TODO: Implement retry scan
                                  },
                                  text: 'Retry Scan',
                                ),
                                const SizedBox(width: 20),
                                AppButtonWidget(
                                  width: 190,
                                  onTap: () {
                                    // TODO: Implement confirm check-in
                                  },
                                  text: 'Confirm Check-In',
                                ),
                              ],
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
                      padding: EdgeInsets.only(top: 100.0, right: screenWidth * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Visitor Check-In',
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
      ),
    );
  }
}