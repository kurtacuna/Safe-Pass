import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Map<String, bool> _isHovering = {};

  // Note to developer:
  // When developing, change the value of _index in the sidebar_notifier.dart file
  // found at ./entrypoint/controllers/sidebar_notifier.dart
  // Do this so that every time Flutter hot restarts, it goes to your screen
  
  // Change _index to 0 after you're done developing your part
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering[title] = true),
      onExit: (_) => setState(() => _isHovering[title] = false),
      child: GestureDetector(
        onTap: onTap,
        child: AppContainerWidget(
          width: 500,
          height: 200,
          backgroundColor: _isHovering[title] == true ? AppColors.kDarkBlue : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 55,
                color: _isHovering[title] == true ? Colors.white : AppColors.kDarkBlue,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.biggerStyleBold.copyWith(
                  color: _isHovering[title] == true ? Colors.white : AppColors.kDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
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
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.kDarkBlue,
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionCard(
                    title: 'New Visitor Registration',
                    icon: Icons.person_add,
                    onTap: () {
                      context.go('/entrypoint/dashboard/register');
                    },
                  ),
                  const SizedBox(width: 24),
                  _buildActionCard(
                    title: 'Check In',
                    icon: Icons.login,
                    onTap: () {
                      context.go('/entrypoint/dashboard/checkin');
                    },
                  ),
                  const SizedBox(width: 24),
                  _buildActionCard(
                    title: 'Check Out',
                    icon: Icons.logout,
                    onTap: () {
                      context.go('/entrypoint/dashboard/checkout');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}