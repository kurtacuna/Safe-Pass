import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/common/utils/widgets/snackbar.dart';
import 'package:safepass_frontend/src/check_in/controller/visit-purpose_controller.dart';
import 'package:safepass_frontend/src/check_in/controller/visitor_search_controller.dart';
import 'package:safepass_frontend/src/check_in/models/visitor_search_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckInScreen extends StatefulWidget { //comment for checkpoint
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _searchController = TextEditingController();
  TextEditingController? _autocompleteController;
  String? _selectedVisitPurpose;
  bool _isFaceRecognized = false;
  bool _isDenied = false;
  bool _showVerificationDialog = false;
  final _searchFieldKey = GlobalKey();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitPurposesController>().fetchVisitPurposes(context);
    });

    super.initState();
  }

  void _handleSearch() {
    // TODO: Implement search functionality
    // For now, simulate finding a visitor
    setState(() {
      _nameController.text = 'John Doe';
      _idNumberController.text = 'VIS-2024-001';
      _selectedVisitPurpose = 'Official Visit';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
                  'Marking this visitor as verified will update their stored face data with the current photo.',
                  style: AppTextStyles.defaultStyle.copyWith(
                    color: AppColors.kDarkGray,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Proceed only if you\'re sure this is the correct person.',
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
                          setState(() {
                            _isFaceRecognized = true;
                          });
                          Navigator.pop(context);
                          // TODO: Implement verification logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kDarkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm and Update',
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
    if (context.watch<VisitPurposesController>().getIsLoading) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    final visitPurposes = context.watch<VisitPurposesController>().getVisitPurposes;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Column(
                children: [
                  // Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => context.go('/entrypoint'),
                          child: Image.asset(
                            AppImages.logoDark,
                            height: 50,
                          ),
                        ),
                      ),
                      // Title with Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/checked_in_icon2.svg',
                            width: 34,
                            height: 34,
                            colorFilter: ColorFilter.mode(
                              AppColors.kDarkBlue,
                              BlendMode.srcIn
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Visitor Check-In',
                            style: AppTextStyles.biggestStyle.copyWith(
                              color: AppColors.kDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Back Button
                      TextButton.icon(
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
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Main Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Search Bar
                      SizedBox(
                        width: 1000,
                        child: Column(
                          children: [
                            AppTextFormFieldWidget(
                              key: _searchFieldKey,
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              hintText: 'Search Visitor ID or Name',
                              prefixIcon: const Icon(Icons.search),
                              onChanged: (value) {
                                print("DEBUG: Search onChanged triggered with value: $value");
                                if (value.isNotEmpty) {
                                  print("DEBUG: Calling searchVisitors with value: $value");
                                  context.read<VisitorSearchController>().searchVisitors(
                                    context,
                                    value,
                                  );
                                }
                              },
                            ),
                            Consumer<VisitorSearchController>(
                              builder: (context, controller, _) {
                                print("DEBUG: Consumer rebuilding with:");
                                print("DEBUG: - Has focus: ${_searchFocusNode.hasFocus}");
                                print("DEBUG: - Search text: ${_searchController.text}");
                                print("DEBUG: - Selected visitor: ${controller.getSelectedVisitor}");
                                print("DEBUG: - Is loading: ${controller.getIsLoading}");
                                print("DEBUG: - Search results count: ${controller.getSearchResults.length}");
                                
                                if (_searchFocusNode.hasFocus && 
                                    _searchController.text.isNotEmpty && 
                                    controller.getSelectedVisitor == null) {
                                  return Container(
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: controller.getIsLoading
                                          ? Container(
                                              padding: const EdgeInsets.all(16),
                                              child: const Center(child: CircularProgressIndicator()),
                                            )
                                          : controller.getSearchResults.isEmpty
                                              ? Container(
                                                  padding: const EdgeInsets.all(16),
                                                  child: const Text('No visitors found'),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: controller.getSearchResults.length,
                                                  itemBuilder: (context, index) {
                                                    final visitor = controller.getSearchResults[index];
                                                    return Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          controller.setSelectedVisitor(visitor);
                                                          _nameController.text = visitor.fullName;
                                                          _idNumberController.text = visitor.idNumber;
                                                          _searchController.text = visitor.toString();
                                                          FocusScope.of(context).unfocus();
                                                          setState(() {}); // Trigger rebuild to hide overlay
                                                        },
                                                        hoverColor: AppColors.kGray.withOpacity(0.1),
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 12,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              bottom: BorderSide(
                                                                color: AppColors.kGray.withOpacity(0.2),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            visitor.toString(),
                                                            style: AppTextStyles.defaultStyle.copyWith(
                                                              color: AppColors.kDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                  ));
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
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
                                    const SizedBox(height: 55),
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
                                                  enabled: false,
                                                  style: AppTextStyles.defaultStyle.copyWith(
                                                    color: AppColors.kDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                AppTextFormFieldWidget(
                                                  controller: _idNumberController,
                                                  hintText: 'Visitor ID Number',
                                                  enabled: false,
                                                  style: AppTextStyles.defaultStyle.copyWith(
                                                    color: AppColors.kDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                AppTextFormFieldWidget(
                                                  controller: TextEditingController(
                                                    text: context.watch<VisitorSearchController>().getSelectedVisitor?.lastVisitDate == 'No previous visits' 
                                                        ? '' 
                                                        : context.watch<VisitorSearchController>().getSelectedVisitor?.lastVisitDate
                                                  ),
                                                  hintText: 'Last Visit',
                                                  enabled: false,
                                                  style: AppTextStyles.defaultStyle.copyWith(
                                                    color: AppColors.kDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.kWhite,
                                                    borderRadius: AppConstants.kAppBorderRadius,
                                                    border: Border.all(color: AppColors.kGray),
                                                  ),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButtonFormField<String>(
                                                      dropdownColor: Colors.white,
                                                      value: _selectedVisitPurpose,
                                                      hint: Text(
                                                        'Visit Purpose',
                                                        style: AppTextStyles.defaultStyle.copyWith(
                                                          color: AppColors.kDark,
                                                        ),
                                                      ),
                                                      style: AppTextStyles.defaultStyle.copyWith(
                                                        color: AppColors.kDark,
                                                      ),
                                                      isExpanded: true,
                                                      decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                                      ),
                                                      items: visitPurposes.map((purpose) {
                                                        print("DEBUG: Creating dropdown item for purpose: ${purpose.purpose}");
                                                        return DropdownMenuItem(
                                                          value: purpose.purpose,
                                                          child: Text(
                                                            purpose.purpose,
                                                            style: AppTextStyles.defaultStyle.copyWith(
                                                              color: AppColors.kDark,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: context.watch<VisitorSearchController>().getSelectedVisitor != null
                                                          ? (String? value) {
                                                              print("DEBUG: Visit purpose selected: $value");
                                                              setState(() {
                                                                _selectedVisitPurpose = value;
                                                              });
                                                              print("DEBUG: Updated selected visit purpose: $_selectedVisitPurpose");
                                                            }
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                AppButtonWidget(
                                                  width: double.infinity,
                                                  onTap: () {
                                                    if (_formKey.currentState!.validate() &&
                                                        _selectedVisitPurpose != null &&
                                                        context.read<VisitorSearchController>().getSelectedVisitor != null) {
                                                      context.read<VisitorSearchController>().checkInVisitor(
                                                        context,
                                                        visitorId: context.read<VisitorSearchController>().getSelectedVisitor!.id,
                                                        visitPurpose: _selectedVisitPurpose!,
                                                      );
                                                      setState(() {
                                                        _selectedVisitPurpose = null;
                                                        _nameController.clear();
                                                        _idNumberController.clear();
                                                        _searchController.clear();
                                                        _autocompleteController?.clear();
                                                      });
                                                    }
                                                  },
                                                  text: 'Confirm Check-In',
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
                                                // TODO: Implement deny visitor
                                              },
                                              text: 'Deny Visitor',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}