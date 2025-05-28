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
import 'package:safepass_frontend/src/check_out/controller/check_out_controller.dart';
import 'package:safepass_frontend/src/check_out/model/visitor_search_result.dart';

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
  final _visitPurposeController = TextEditingController();
  String? _selectedVisitPurpose;
  bool _isFaceRecognized = false;
  bool _isDenied = false;
  bool _showVerificationDialog = false;
  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  VisitorSearchResult? _selectedVisitor;
  final GlobalKey _searchFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      _hideOverlay();
    } else {
      context.read<CheckOutController>().searchVisitors(context, _searchController.text);
      if (_searchFocusNode.hasFocus) {
        _showOverlay();
      }
    }
  }

  void _showOverlay() {
    _hideOverlay();

    // Get the RenderBox of the search field using its GlobalKey
    final RenderBox? searchField = _searchFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (searchField == null) {
      print('Search field RenderBox is null');
      return;
    }

    final Size searchFieldSize = searchField.size;
    final Offset searchFieldOffset = searchField.localToGlobal(Offset.zero);
    
    print('Search field position: ${searchFieldOffset.dx}, ${searchFieldOffset.dy}');
    print('Search field size: ${searchFieldSize.width}, ${searchFieldSize.height}');

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: searchFieldOffset.dy + searchFieldSize.height,
        left: searchFieldOffset.dx,
        width: searchFieldSize.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Consumer<CheckOutController>(
            builder: (context, controller, _) {
              print('Building overlay: isLoading=${controller.getIsLoading}, results=${controller.getSearchResults.length}');
              
              if (controller.getIsLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.getSearchResults.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: const Text('No visitors found'),
                );
              }

              return Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.getSearchResults.length,
                  itemBuilder: (context, index) {
                    final visitor = controller.getSearchResults[index];
                    return ListTile(
                      title: Text(visitor.toString()),
                      onTap: () {
                        _selectVisitor(visitor);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectVisitor(VisitorSearchResult visitor) {
    print('Selected visitor: ${visitor.toString()}');
    print('Visitor details - ID: ${visitor.id}, Name: ${visitor.fullName}, ID Number: ${visitor.idNumber}');
    
    setState(() {
      _selectedVisitor = visitor;
      _searchController.text = visitor.toString();
      _nameController.text = visitor.fullName;
      _idNumberController.text = visitor.idNumber;
      _selectedVisitPurpose = visitor.visitPurpose ?? 'Not Available';
      _visitPurposeController.text = _selectedVisitPurpose!;
    });
    
    print('Updated fields - Name: ${_nameController.text}, ID: ${_idNumberController.text}, Purpose: $_selectedVisitPurpose');
    _hideOverlay();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _nameController.dispose();
    _idNumberController.dispose();
    _visitPurposeController.dispose();
    _searchFocusNode.dispose();
    _hideOverlay();
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
                          setState(() {
                            _isFaceRecognized = true;
                          });
                          Navigator.pop(context);
                          if (_selectedVisitor != null) {
                            context.read<CheckOutController>().checkOutVisitor(
                              context,
                              _selectedVisitor!.id,
                            );
                          }
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
                    child: AppTextFormFieldWidget(
                      key: _searchFieldKey,
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      hintText: 'Search Visitor ID',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 70),
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
                                            ),
                                            const SizedBox(height: 30),
                                            AppTextFormFieldWidget(
                                              controller: _idNumberController,
                                              hintText: 'Visitor ID Number',
                                              enabled: false,
                                            ),
                                            const SizedBox(height: 30),
                                            AppTextFormFieldWidget(
                                              controller: _visitPurposeController,
                                              hintText: 'Visit Purpose',
                                              enabled: false,
                                            ),
                                            const SizedBox(height: 30),
                                            AppButtonWidget(
                                              width: double.infinity,
                                              onTap: () {
                                                if (_formKey.currentState!.validate() && _selectedVisitor != null) {
                                                  context.read<CheckOutController>().checkOutVisitor(
                                                    context,
                                                    _selectedVisitor!.id,
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
            ),
          ],
        ),
      ),
    );
  }
}