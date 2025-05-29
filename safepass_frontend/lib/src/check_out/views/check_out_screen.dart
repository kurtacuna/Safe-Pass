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
    print('DEBUG: Initializing CheckOutScreen');
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      print('DEBUG: Search focus changed - hasFocus: ${_searchFocusNode.hasFocus}');
      if (_searchFocusNode.hasFocus) {
        _showOverlay();
      } else {
        // Add a small delay before hiding overlay to allow for click handling
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!_searchFocusNode.hasFocus) {
            _hideOverlay();
          }
        });
      }
    });
  }

  void _onSearchChanged() {
    print('DEBUG: Search text changed: ${_searchController.text}');
    if (_searchController.text.isEmpty) {
      print('DEBUG: Search text is empty, hiding overlay');
      _hideOverlay();
    } else {
      print('DEBUG: Calling searchVisitors with query: ${_searchController.text}');
      context.read<CheckOutController>().searchVisitors(context, _searchController.text);
      if (_searchFocusNode.hasFocus) {
        print('DEBUG: Search has focus, showing overlay');
        _showOverlay();
      }
    }
  }

  void _handleVisitorSelection(VisitorSearchResult visitor) {
    print('DEBUG: Handling visitor selection');
    print('DEBUG: Selected visitor data:');
    print('ID: ${visitor.id}');
    print('ID Number: ${visitor.idNumber}');
    print('Full Name: ${visitor.fullName}');
    print('Visit Purpose: ${visitor.visitPurpose}');

    setState(() {
      _selectedVisitor = visitor;
      _searchController.text = visitor.toString();
      _nameController.text = visitor.fullName;
      _idNumberController.text = visitor.idNumber;
      _visitPurposeController.text = visitor.visitPurpose ?? 'Not Available';
    });

    print('DEBUG: Updated form fields:');
    print('Search Text: ${_searchController.text}');
    print('Name: ${_nameController.text}');
    print('ID Number: ${_idNumberController.text}');
    print('Visit Purpose: ${_visitPurposeController.text}');

    context.read<CheckOutController>().setSelectedVisitor(visitor);
    _hideOverlay();
    FocusScope.of(context).unfocus();
  }

  void _showOverlay() {
    print('DEBUG: Showing overlay');
    _hideOverlay();

    // Get the RenderBox of the search field using its GlobalKey
    final RenderBox? searchField = _searchFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (searchField == null) {
      print('ERROR: Search field RenderBox is null');
      return;
    }

    final Size searchFieldSize = searchField.size;
    final Offset searchFieldOffset = searchField.localToGlobal(Offset.zero);
    
    print('DEBUG: Search field position: ${searchFieldOffset.dx}, ${searchFieldOffset.dy}');
    print('DEBUG: Search field size: ${searchFieldSize.width}, ${searchFieldSize.height}');

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
              print('DEBUG: Building overlay - isLoading: ${controller.getIsLoading}, results: ${controller.getSearchResults.length}');
              
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
                child: Material(
                  color: Colors.transparent,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.getSearchResults.length,
                    itemBuilder: (context, index) {
                      final visitor = controller.getSearchResults[index];
                      print('DEBUG: Showing visitor in list: ${visitor.toString()}');
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleVisitorSelection(visitor),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.kGray.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                visitor.toString(),
                                style: AppTextStyles.defaultStyle.copyWith(
                                  color: AppColors.kDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                            // Clear the form after successful check-out
                            setState(() {
                              _selectedVisitor = null;
                              _searchController.clear();
                              _nameController.clear();
                              _idNumberController.clear();
                              _visitPurposeController.clear();
                              _isFaceRecognized = false;
                            });
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

  Widget _buildSearchResults(BuildContext context, CheckOutController controller) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.getSearchResults.length,
        itemBuilder: (context, index) {
          final visitor = controller.getSearchResults[index];
          print('DEBUG: Building list item for visitor:');
          print('ID: ${visitor.id}');
          print('Display String: ${visitor.toString()}');
          
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleVisitorSelection(visitor),
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
                    child: Column(
                      children: [
                        AppTextFormFieldWidget(
                          key: _searchFieldKey,
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          hintText: 'Search Visitor ID',
                          prefixIcon: const Icon(Icons.search),
                        ),
                        Consumer<CheckOutController>(
                          builder: (context, controller, _) {
                            if (_searchFocusNode.hasFocus || controller.getSearchResults.isNotEmpty) {
                              return _buildSearchResults(context, controller);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
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
                                                  _showReminderDialog();
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