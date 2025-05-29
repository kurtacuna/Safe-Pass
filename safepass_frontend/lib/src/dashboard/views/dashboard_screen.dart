import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_container_widget_offset.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_stat_card_widget.dart';
import 'package:safepass_frontend/src/dashboard/widgets/app_visitor_logs.dart';
import 'package:safepass_frontend/src/dashboard/models/visitor_stats_model.dart';
import 'package:safepass_frontend/src/dashboard/services/visitor_stats_service.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  VisitorStats? _visitorStats;
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadVisitorStats();
    // Set up periodic refresh every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadVisitorStats();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadVisitorStats() async {
    try {
      print('Starting to load visitor stats...'); // Debug print
      var stats = await VisitorStatsService.getVisitorStats(context);
      if (stats == null) {
        print("debug: empty stats. refetching");
        await refetch(context, fetch: () async {
          stats = await VisitorStatsService.getVisitorStats(context);
        });
      }
      print('Received visitor stats: ${stats?.totalVisitors}, ${stats?.checkedIn}, ${stats?.checkedOut}, ${stats?.newRegistrants}'); // Debug print
      if (mounted) {
        setState(() {
          _visitorStats = stats;
          _isLoading = false;
        });
      }
      print('Stats updated in state: ${_visitorStats?.totalVisitors}, ${_visitorStats?.checkedIn}, ${_visitorStats?.checkedOut}, ${_visitorStats?.newRegistrants}'); // Debug print
    } catch (e) {
      print('Error loading stats: $e'); // Debug print
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // You might want to show an error message here
    }
  }

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

  Widget _buildStatCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    print('Building stat cards with stats: ${_visitorStats?.totalVisitors}, ${_visitorStats?.checkedIn}, ${_visitorStats?.checkedOut}, ${_visitorStats?.newRegistrants}'); // Debug print

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 30,
      runSpacing: 52,
      children: [
        AppStatCardWidget(
          count: _visitorStats?.totalVisitors.toString() ?? '0',
          label: 'Total Visitors',
          totalIconPath: 'assets/images/total_icon.png',
          bottomIconPath: 'assets/images/total_visitors.png',
        ),
        AppStatCardWidget(
          count: _visitorStats?.checkedIn.toString() ?? '0',
          label: 'Checked-in',
          totalIconPath:  'assets/images/total_icon.png',
          bottomIconPath: 'assets/images/checked_in_visitors.png',
        ),
        AppStatCardWidget(
          count: _visitorStats?.checkedOut.toString() ?? '0',
          label: 'Checked-out',
          totalIconPath: 'assets/images/total_icon.png',
          bottomIconPath: 'assets/images/checked_out_stats_icon.png',
        ),
        AppStatCardWidget(
          count: _visitorStats?.newRegistrants.toString() ?? '0',
          label: 'New Registrants',
          totalIconPath: 'assets/images/total_icon.png',
          bottomIconPath: 'assets/images/pending_stats_icon.png',
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
                _buildStatCards(),
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
