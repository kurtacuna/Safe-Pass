import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart';
import 'package:safepass_frontend/src/settings/models/visitor_details_model.dart';
import 'package:safepass_frontend/src/visitor/controllers/visitor_details_controller.dart';
import '../widgets/visitor_header_widget.dart';
import '../widgets/visitor_info_widget.dart';
import '../widgets/visitor_action_buttons.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';

class VisitorDetailsScreen extends StatefulWidget {
  const VisitorDetailsScreen({
    required this.visitorDetails,
    super.key
  });

  final Visitor? visitorDetails;

  @override
  State<VisitorDetailsScreen> createState() => _VisitorDetailsScreenState();
}

class _VisitorDetailsScreenState extends State<VisitorDetailsScreen> {
  List<CameraDescription> cameras = [];
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool previewCamera = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

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

  Future<void> _takePictureAndSend() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _cameraController.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();
      if (context.mounted) {
        await context.read<VisitorDetailsController>().uploadPhoto(
          context: context,
          imageBytes: imageBytes,
          imageName: image.name,
          id: widget.visitorDetails!.id.toString()
        );
      }
    } catch (e) {
      print("_takePictureAndSend:");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.kDarkRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VisitorHeaderWidget(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Visitor's Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
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
                                  : Image.network(
                                      ApiUrls.getImageUrl(widget.visitorDetails!.photo),
                                      width: double.infinity,
                                      height: double.infinity
                                    )
                              ),
                              SizedBox(height: 20),
                              AppButtonWidget(
                                onTap: () {
                                  _loadCameras();
                                },
                                text: 'Open Camera'
                              ),
                              SizedBox(height: 20),
                              AppButtonWidget(
                                onTap: () {
                                  _takePictureAndSend();
                                },
                                text: 'Update Photo',
                                
                              )
                            ]
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: VisitorInfoWidget(visitor: widget.visitorDetails),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 