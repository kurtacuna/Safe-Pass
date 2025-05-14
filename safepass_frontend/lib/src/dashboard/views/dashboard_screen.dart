import 'package:flutter/material.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_container_widget_offset.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_stat_card_widget.dart';
import 'package:safepass_frontend/common/widgets/app_admin_profile.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_visitor_logs.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppAdminProfile(
                            name: 'Juan Dela Cruz',
                            imagePath: 'assets/images/admin_photo.png',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 52,
                        children: [
                          AppIconCardWidget(
                            svgAssetPath: 'assets/images/new_visitor_symbol.svg',
                            label: 'New User Registration',
                            onTap: () {
                              // TODO: Navigate to registration screen
                            },
                          ),
                          AppIconCardWidget(
                            svgAssetPath: 'assets/images/check_in_symbol.svg',
                            label: 'Check In',
                            onTap: () {
                              // TODO: Navigate to Check In
                            },
                          ),
                          AppIconCardWidget(
                            svgAssetPath: 'assets/images/check_out_symbol.svg',
                            label: 'Check Out',
                            onTap: () {
                              // TODO: Navigate to Check Out
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 52,
                        runSpacing: 52,
                        children: const [
                          AppStatCardWidget(
                            count: '105',
                            label: 'Total Visitors',
                            totalIconPath: 'assets/images/total_icon.png',
                            bottomIconPath: 'assets/images/total_visitors.png',
                          ),
                          AppStatCardWidget(
                            count: '80',
                            label: 'Checked-in',
                            totalIconPath: 'assets/images/checked_in_visitors.png',
                            bottomIconPath: 'assets/images/checked_in_visitors.png',
                          ),
                          AppStatCardWidget(
                            count: '30',
                            label: 'Checked-out',
                            totalIconPath: 'assets/images/total_icon.png',
                            bottomIconPath: 'assets/images/checked_out_stats_icon.png',
                          ),
                          AppStatCardWidget(
                            count: '5',
                            label: 'New Registrants',
                            totalIconPath: 'assets/images/total_icon.png',
                            bottomIconPath: 'assets/images/pending_stats_icon.png',
                          ),
                        ],
                      ),

                      const SizedBox(height: 42),

                      const VisitorLogsWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
