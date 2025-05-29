import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/cookies.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/common/utils/widgets/snackbar.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/src/registration/controller/id_types_controller.dart';
import 'package:safepass_frontend/src/registration/models/id_types_model.dart';

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
  final _contactNumberController = TextEditingController();
  String? _selectedIdType;
  bool _isLoading = false;
  List<String> _idTypes = [];

  List<CameraDescription> cameras = [];
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool previewCamera = false;

  void _loadCameras() async {
    cameras = await availableCameras();

    print("debug: list of cameras ${cameras}");

    _cameraController = CameraController(
      cameras.firstWhere(
        (e) => e.name == "Logi C270 HD WebCam (046d:0825)",
        orElse: () => cameras.first
      ),
      ResolutionPreset.high
    );
    _initializeControllerFuture = _cameraController.initialize();

    setState(() {
      previewCamera = true;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IdTypesController>().fetchIdTypes(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _contactNumberController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _registerVisitor() async {
    if (!mounted) return;  // Check if widget is still mounted
    
    if (previewCamera == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please turn on the camera first"),
          backgroundColor: AppColors.kDarkRed,
        )
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      AppSnackbar.showError(context, 'Please fill in all required fields');
      return;
    }

    if (_selectedIdType == null) {
      AppSnackbar.showError(context, 'Please select an ID type');
      return;
    }

    await _initializeControllerFuture;
      final XFile image = await _cameraController.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

    setState(() {
      _isLoading = true;
    });

    try {
      var client = BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.registrationUrl);
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: "imagefromclient.jpeg",
          contentType: MediaType('image', 'jpeg')
        )
      );
      request.headers['X-CSRFToken'] = AppCookies.getCSRFToken();
      request.fields['reg_details'] = json.encode({
        'first_name': _firstNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'id_type': _selectedIdType,
        'id_number': _idNumberController.text,
        'contact_number': _contactNumberController.text,
      });

      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 201) {
        if (!mounted) return;  // Check if widget is still mounted
        
        // Clear form fields after successful registration
        _firstNameController.clear();
        _middleNameController.clear();
        _lastNameController.clear();
        _idNumberController.clear();
        _contactNumberController.clear();
        _cameraController.pausePreview();
        setState(() {
          _selectedIdType = null;
          previewCamera = false;
        });
        
        // Show success message after state is updated
        if (mounted) {  // Check again before showing snackbar
          AppSnackbar.showSuccess(context, 'Registration successful! Ready for next visitor.');
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => _registerVisitor());
        }
      } else {
        final errorData = json.decode(response.body);
        String errorMessage = 'Registration failed: ';
        if (errorData is Map<String, dynamic>) {
          if (errorData.containsKey('detail')) {
            errorMessage += errorData['detail'];
          } else {
            errorMessage += json.encode(errorData);
          }
        } else {
          errorMessage += 'Unexpected response format';
        }
        AppSnackbar.showError(context, errorMessage);
      }
    } catch (e) {
      print('Registration Error: $e');
      AppSnackbar.showError(
        context, 
        'Connection error: Please ensure the backend server is running at http://127.0.0.1:8000/api'
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _scanFace() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     var client = BrowserClient();
  //     client.withCredentials = true;
  //     final response = await client.post(Uri.parse(ApiUrls.registerFaceUrl));
      
  //     if (response.statusCode == 200) {
  //       AppSnackbar.showSuccess(context, 'Face scan successful!');
  //     } else {
  //       AppSnackbar.showError(context, 'Face scan failed. Please try again.');
  //     }
  //   } catch (e) {
  //     AppSnackbar.showError(
  //       context, 
  //       'An error occurred during face scan. Please try again.'
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (context.watch<IdTypesController>().getIsLoading) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    _idTypes = context.read<IdTypesController>().getIdTypes.map((e) => e.type).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Back to Dashboard Button
            Positioned(
              top: 50,
              right: 50,
              child: TextButton.icon(
                onPressed: _isLoading 
                  ? null 
                  : () {
                    context.go('/entrypoint');
                    _cameraController.dispose();
                  },
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

            // Logo
            Positioned(
              top: 50,
              left: 50,
              child: Image.asset(
                AppImages.logoDark,
                height: 50,
              ),
            ),

            // Main Content - Centered
            Padding(
              padding: const EdgeInsets.only(top: 200.0, bottom: 50),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Visitor Details Form
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                              const SizedBox(height: 40),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 400),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      AppTextFormFieldWidget(
                                        controller: _firstNameController,
                                        hintText: 'Enter your first name',
                                        validatorText: 'Please enter your first name',
                                      ),
                                      const SizedBox(height: 20),
                                      AppTextFormFieldWidget(
                                        controller: _middleNameController,
                                        hintText: 'Enter your middle name',
                                      ),
                                      const SizedBox(height: 20),
                                      AppTextFormFieldWidget(
                                        controller: _lastNameController,
                                        hintText: 'Enter your last name',
                                        validatorText: 'Please enter your last name',
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.kLighterGray,
                                          borderRadius: AppConstants.kAppBorderRadius,
                                          border: Border.all(color: AppColors.kGray),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<String>(
                                            value: _selectedIdType,
                                            hint: const Text('ID Type'),
                                            style: AppTextStyles.defaultStyle,
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                                      const SizedBox(height: 20),
                                      AppTextFormFieldWidget(
                                        controller: _idNumberController,
                                        hintText: 'Enter your ID Number',
                                        validatorText: 'Please enter your ID number',
                                      ),
                                      const SizedBox(height: 20),
                                      AppTextFormFieldWidget(
                                        controller: _contactNumberController,
                                        hintText: 'Enter your contact number',
                                        validatorText: 'Please enter your contact number',
                                        keyboardType: TextInputType.phone,
                                        digitsOnly: true,
                                      ),
                                      // const SizedBox(height: 30),
                                      // AppButtonWidget(
                                      //   width: double.infinity,
                                      //   onTap: _isLoading ? null : _registerVisitor,
                                      //   text: _isLoading ? 'Registering...' : 'Enter Visitor',
                                      //   isLoading: _isLoading,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Right side - Face Recognition
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'New Visitor Registration',
                                style: AppTextStyles.biggestStyle.copyWith(
                                  color: AppColors.kDarkBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Face Identity Registration',
                                style: AppTextStyles.biggerStyle.copyWith(
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
                                  child: previewCamera
                                      ? FutureBuilder(
                                          future: _initializeControllerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              return SizedBox.expand(
                                                child: CameraPreview(_cameraController)
                                              );
                                            } else {
                                              return Center(child: AppCircularProgressIndicatorWidget(),);
                                            }
                                          }
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Face Not Registered',
                                                style: AppTextStyles.bigStyle.copyWith(
                                                  color: AppColors.kDarkGray,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              AppButtonWidget(
                                                width: 200,
                                                onTap: _isLoading 
                                                  ? null 
                                                  : () => _loadCameras(),
                                                text: _isLoading ? 'Scanning...' : 'TAKE A PHOTO',
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 600),
                                child: Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  children: [
                                    AppButtonWidget(
                                      width: 150,
                                      onTap: () {
                                        // Clear form and reset
                                        _firstNameController.clear();
                                        _middleNameController.clear();
                                        _lastNameController.clear();
                                        _idNumberController.clear();
                                        _contactNumberController.clear();
                                        setState(() {
                                          _selectedIdType = null;
                                          previewCamera = false;
                                          _cameraController.pausePreview();
                                        });
                                      },
                                      text: 'Reset Form',
                                      color: AppColors.kGray,
                                    ),
                                    // const SizedBox(width: 20),
                                    AppButtonWidget(
                                      width: 150,
                                      onTap: _isLoading ? null : () => _registerVisitor(),
                                      text: _isLoading ? 'Registering...' : 'Register',
                                      isLoading: _isLoading,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}