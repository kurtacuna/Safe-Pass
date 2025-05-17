import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/assets/icons.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    this.centerLogo,
    this.navigatorPop,
    super.key
  });

  final bool? centerLogo;

  // Used to pop the navigation history to close the drawer
  final bool? navigatorPop;

  @override
  Widget build(BuildContext context) {
    return Consumer<SidebarNotifier>(
      builder: (context, sidebarNotifier, child) {
        return Expanded(
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                centerLogo == true
                  ? Center(
                      child: Image.asset(
                        AppImages.logoDark,
                        height: 50
                      ),
                    )
                  : Image.asset(
                      AppImages.logoDark,
                      height: 50
                    ),
            
                SizedBox(height: 40),
            
                ListTile(
                  onTap: () {
                    sidebarNotifier.setIndex = 0;
                    if (navigatorPop == true) {
                      context.pop();
                    }
                  },
                  selected: sidebarNotifier.getIndex == 0
                    ? true
                    : false,
                  leading: AppIcons.chartIcon,
                  title: Center(
                    child: Text(
                      "Dashboard",
                      style: AppTextStyles.defaultStyle
                    )
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                ),
                ListTile(
                  onTap: () {
                    sidebarNotifier.setIndex = 1;
                    if (navigatorPop == true) {
                      context.pop();
                    }
                  },
                  selected: sidebarNotifier.getIndex == 1 || sidebarNotifier.getIndex == 3
                    ? true
                    : false,
                  leading: AppIcons.chartIcon,
                  title: Center(
                    child: Text(
                      "Logs",
                      style: AppTextStyles.defaultStyle
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    sidebarNotifier.setIndex = 2;
                    if (navigatorPop == true) {
                      context.pop();
                    }
                  },
                  selected: sidebarNotifier.getIndex == 2
                    ? true
                    : false,
                  leading: AppIcons.chartIcon,
                  title: Center(
                    child: Text(
                      "Settings",
                      style: AppTextStyles.defaultStyle
                    )
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}