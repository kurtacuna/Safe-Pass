import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/src/settings/models/visitor_details_model.dart';
import '../widgets/visitor_header_widget.dart';
import '../widgets/visitor_info_widget.dart';
import '../widgets/visitor_action_buttons.dart';

class VisitorDetailsScreen extends StatelessWidget {
  const VisitorDetailsScreen({
    required this.visitorDetails,
    super.key
  });

  final Visitor? visitorDetails;

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
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              ApiUrls.getImageUrl(visitorDetails!.photo),
                              width: double.infinity,
                              height: double.infinity
                            )
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: VisitorInfoWidget(visitor: visitorDetails),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const VisitorActionButtons(),
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