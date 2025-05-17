import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/utils/responsive.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';
import 'package:safepass_frontend/src/settings/views/subviews/database_tab.dart';
import 'package:safepass_frontend/src/settings/views/subviews/general_tab.dart';
import 'package:safepass_frontend/src/settings/views/subviews/policies_tab.dart';
import 'package:safepass_frontend/src/settings/widgets/settings_tab_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Note to developer:
  // When developing, change the value of _index in the sidebar_notifier.dart file
  // found at ./entrypoint/controllers/sidebar_notifier.dart
  // Do this so that every time Flutter hot restarts, it goes to your screen
  
  // Change _index to 0 after you're done developing your part

  static const List<Widget> tabs = [
    GeneralTab(),
    DatabaseTab(),
    PoliciesTab()
  ];

  @override
  Widget build(BuildContext context) {
    int tabIndex = context.watch<SettingsTabNotifier>().getTabIndex;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: AppResponsive(context).responsiveWidget(
            small: SettingsContainer(
              appContainerWidget: AppContainerWidget(
                width: double.infinity, 
                height: 550, 
                child: tabs[tabIndex]
              ),
            ),
            large: SettingsContainer(
              appContainerWidget: AppContainerWidget(
                width: 1500, 
                height: 550, 
                child: tabs[tabIndex]
              ),
            )
          )
        )
      )
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({
    required this.appContainerWidget,
    super.key
  });

  final Widget appContainerWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SettingsTabWidget(
              text: "General", 
              index: 0
            ),
            SettingsTabWidget(
              text: "Database", 
              index: 1
            ),
            SettingsTabWidget(
              text: "Policies", 
              index: 2
            ),
          ]
        ),
        appContainerWidget,
      ]
    );
  }
}