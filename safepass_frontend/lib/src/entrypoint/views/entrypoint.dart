import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/assets/icons.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/const/kglobal_keys.dart';
import 'package:safepass_frontend/common/utils/responsive.dart';
import 'package:safepass_frontend/src/dashboard/views/dashboard_screen.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import 'package:safepass_frontend/src/entrypoint/widgets/sidebar.dart';
import 'package:safepass_frontend/src/logs/views/logs_screen.dart';
import 'package:safepass_frontend/src/settings/views/settings_screen.dart';

class Entrypoint extends StatelessWidget {
  const Entrypoint({super.key});

  static const List<Widget> screens = [
    DashboardScreen(),
    LogsScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sidebar in a drawer for when the window is small
      key: AppGlobalKeys.drawer,
      drawer: Drawer(
        width: 200,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Sidebar(
            centerLogo: true,
            navigatorPop: true,
          )
        )
      ),

      // A row layout for the whole screen
      body: Stack(
        children: [
          Padding(
            padding: AppConstants.kAppPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppResponsive(context).responsiveWidget(
                  small: Container(),
                  large: SizedBox(
                    width: 150,
                    child: Sidebar()
                  ),
                ),
            
                AppResponsive(context).responsiveWidget(
                  small: Container(),
                  large: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10
                    ),
                    child: Row(
                      children: [
                        VerticalDivider(),
                        SizedBox(width: 30)
                      ]
                    ),
                  )
                ),
            
                Expanded(
                  child: Center(
                    child: screens[context.watch<SidebarNotifier>().getIndex]
                  )
                )
              ]
            )
          ),

          // Menu button on a small window
          AppResponsive(context).responsiveWidget(
            small: Positioned(
              left: 10,
              top: 10,
              child: InkWell(
                onTap: () {
                  AppGlobalKeys.drawer.currentState?.openDrawer();
                },
                borderRadius: AppConstants.kAppBorderRadius,
                child: Ink(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: AppIcons.menuIcon
                  )
                )
              )
            ), 
            large: Container()
          )
        ]
      )
    );
  }
}