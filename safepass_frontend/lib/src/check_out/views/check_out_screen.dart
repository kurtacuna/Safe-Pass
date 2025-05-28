import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/common/utils/widgets/snackbar.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _lastVisitController = TextEditingController();
  final _visitPurposeController = TextEditingController();
  final _checkOutTimeController = TextEditingController();
  bool _isFaceRecognized = false;
  bool _isDenied = false;
  bool _showVerificationDialog = false;
  DateTime? _selectedCheckOutTime;
  String? _selectedVisitPurpose;

  final List<String> _visitPurposes = [
    'Legal Consultation',
    'Family Visit',
    'Official Visit',
    'Religious Visit/Pastoral Counseling',
    'Educational/Rehabilitative Program Visit',
    'Media Visit',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Set current time as default check-out time
    _selectedCheckOutTime = DateTime.now();
    _checkOutTimeController.text = _formatDateTime(_selectedCheckOutTime!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _idNumberController.dispose();
    _lastVisitController.dispose();
    _visitPurposeController.dispose();
    _checkOutTimeController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectCheckOutTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedCheckOutTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedCheckOutTime ?? DateTime.now()),
      );
      if (timePicked != null) {
        setState(() {
          _selectedCheckOutTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
          _checkOutTimeController.text = _formatDateTime(_selectedCheckOutTime!);
        });
      }
    }
  }

  void _handleSearch() {
    // TODO: Implement search functionality
    // For now, simulate finding a visitor
    setState(() {
      _nameController.text = 'John Doe';
      _idNumberController.text = 'VIS-2024-001';
      _lastVisitController.text = '2024-03-15 09:30';
      _selectedVisitPurpose = 'Official Visit';
    });
  }

  void _showReminderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reminder',
                      style: AppTextStyles.bigStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to check out this visitor?',
                  style: AppTextStyles.defaultStyle.copyWith(
                    color: AppColors.kDarkGray,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone.',
                  style: AppTextStyles.defaultStyle.copyWith(
                    color: AppColors.kDarkGray,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: AppColors.kGray),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.defaultStyle.copyWith(
                            color: AppColors.kDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isFaceRecognized = true;
                          });
                          // TODO: Implement check-out logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kDarkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm Check-Out',
                          style: AppTextStyles.defaultStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Logo and Back Button
            Positioned(
              top: 50,
              left: 50,
              child: Image.asset(
                AppImages.logoDark,
                height: 50,
              ),
            ),
            Positioned(
              top: 50,
              right: 50,
              child: TextButton.icon(
                onPressed: () => context.go('/entrypoint'),
                icon: const Icon(Icons.arrow_back, color: AppColors.kDarkBlue),
                label: Text(
                  'Back to Dashboard',
                  style: AppTextStyles.bigStyle.copyWith(
                    color: AppColors.kDarkBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 120, 50, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Visitor Check-Out',
                    style: AppTextStyles.biggestStyle.copyWith(
                      color: AppColors.kDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Search Bar
                  SizedBox(
                    width: 1000,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextFormFieldWidget(
                            controller: _searchController,
                            hintText: 'Search Visitor ID',
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                        const SizedBox(width: 16),
                        AppButtonWidget(
                          width: 120,
                          onTap: _handleSearch,
                          text: 'Search',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 55),
                  // Two Column Layout
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column - Visitor Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 400),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Visitor\'s Details',
                                        style: AppTextStyles.biggestStyle.copyWith(
                                          color: AppColors.kDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            AppTextFormFieldWidget(
                                              controller: _nameController,
                                              hintText: 'Name',
                                              validatorText: 'Please enter visitor name',
                                              enabled: true,
                                            ),
                                            const SizedBox(height: 30),
                                            AppTextFormFieldWidget(
                                              controller: _idNumberController,
                                              hintText: 'ID Number',
                                              validatorText: 'Please enter ID number',
                                              enabled: true,
                                            ),
                                            const SizedBox(height: 30),
                                            AppTextFormFieldWidget(
                                              controller: _lastVisitController,
                                              hintText: 'Last Visit',
                                              validatorText: 'Please enter last visit date',
                                              enabled: true,
                                            ),
                                            const SizedBox(height: 30),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.kLighterGray,
                                                borderRadius: AppConstants.kAppBorderRadius,
                                                border: Border.all(color: AppColors.kGray),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButtonFormField<String>(
                                                  value: _selectedVisitPurpose,
                                                  hint: const Text('Visit Purpose'),
                                                  style: AppTextStyles.defaultStyle,
                                                  isExpanded: true,
                                                  decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please select visit purpose';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            GestureDetector(
                                              onTap: _selectCheckOutTime,
                                              child: AbsorbPointer(
                                                child: AppTextFormFieldWidget(
                                                  controller: _checkOutTimeController,
                                                  hintText: 'Check-Out Time',
                                                  validatorText: 'Please select check-out time',
                                                  enabled: true,
                                                  suffixIcon: const Icon(Icons.calendar_today),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            AppButtonWidget(
                                              width: double.infinity,
                                              onTap: () {
                                                if (_formKey.currentState!.validate()) {
                                                  AppSnackbar.showSuccess(
                                                    context,
                                                    'Visitor successfully checked out!'
                                                  );
                                                }
                                              },
                                              text: 'Confirm Check-Out',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 50),
                          // Right Column - Face Recognition
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Face Identity Confirmation',
                                  style: AppTextStyles.biggestStyle.copyWith(
                                    color: AppColors.kDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 600),
                                  child: Container(
                                    width: double.infinity,
                                    height: 400,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: AppConstants.kAppBorderRadius,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (_isDenied) ...[
                                            Icon(
                                              Icons.cancel,
                                              size: 64,
                                              color: AppColors.kDarkRed,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Face Not Recognized',
                                              style: AppTextStyles.bigStyle.copyWith(
                                                color: AppColors.kDarkRed,
                                              ),
                                            ),
                                          ] else if (_isFaceRecognized) ...[
                                            Icon(
                                              Icons.check_circle,
                                              size: 64,
                                              color: AppColors.kLightGreen,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Face Recognized',
                                              style: AppTextStyles.bigStyle.copyWith(
                                                color: AppColors.kLightGreen,
                                              ),
                                            ),
                                          ] else ...[
                                            Text(
                                              'Face Not Recognized',
                                              style: AppTextStyles.bigStyle.copyWith(
                                                color: AppColors.kDarkGray,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            AppButtonWidget(
                                              width: 200,
                                              onTap: () {
                                                // TODO: Implement photo capture
                                              },
                                              text: 'TAKE A PHOTO',
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (!_isFaceRecognized)
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 600),
                                    child: Wrap(
                                      spacing: 20,
                                      runSpacing: 10,
                                      children: [
                                        AppButtonWidget(
                                          width: 150,
                                          onTap: () {
                                            setState(() {
                                              _isDenied = true;
                                              _isFaceRecognized = false;
                                            });
                                            // TODO: Implement deny check-out
                                          },
                                          text: 'Deny Check-Out',
                                          color: AppColors.kGray,
                                        ),
                                        AppButtonWidget(
                                          width: 150,
                                          onTap: _showReminderDialog,
                                          text: 'Mark As Verified',
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
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