import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_container_widget_offset.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_stat_card_widget.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_visitor_logs.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
          iconSize: 24,
          color: AppColors.kDarkBlue,
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              child: Image.asset(
                'assets/images/admin_photo.png'
              )
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Admin Name',
                  style: AppTextStyles.smallStyle.copyWith(
                    color: AppColors.kDark,
                  ),
                ),
                Text(
                  'Admin account',
                  style: AppTextStyles.smallStyle.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildTopBar(),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppIconCardWidget(
                          svgAssetPath: 'assets/images/new_visitor_symbol.svg',
                          label: 'New Visitor Registration',
                          onTap: () {
                            context.go('/entrypoint/dashboard/register');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppIconCardWidget(
                          svgAssetPath: 'assets/images/check_in_symbol.svg',
                          label: 'Check In',
                          onTap: () {
                            context.go('/entrypoint/dashboard/checkin');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppIconCardWidget(
                          svgAssetPath: 'assets/images/check_out_symbol.svg',
                          label: 'Check Out',
                          onTap: () {
                            context.go('/entrypoint/dashboard/checkout');
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: AppStatCardWidget(
                          count: '105',
                          label: 'Total Visitors',
                          totalIconPath: 'assets/images/total_icon.png',
                          bottomIconPath: 'assets/images/total_visitors.png',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: AppStatCardWidget(
                          count: '80',
                          label: 'Checked-in',
                          totalIconPath: 'assets/images/checked_in_visitors.png',
                          bottomIconPath: 'assets/images/checked_in_visitors.png',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: AppStatCardWidget(
                          count: '30',
                          label: 'Checked-out',
                          totalIconPath: 'assets/images/total_icon.png',
                          bottomIconPath: 'assets/images/checked_out_stats_icon.png',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: AppStatCardWidget(
                          count: '5',
                          label: 'New Registrants',
                          totalIconPath: 'assets/images/total_icon.png',
                          bottomIconPath: 'assets/images/pending_stats_icon.png',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 42),

                const VisitorLogsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
