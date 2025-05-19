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
        child: AppResponsive(context).responsiveWidget(
          small: SettingsContainer(
            appContainerWidget: AppContainerWidget(
              width: double.infinity, 
              height: double.infinity, 
              child: tabs[tabIndex]
            ),
          ),
          large: SettingsContainer(
            appContainerWidget: AppContainerWidget(
              width: 1500, 
              height: double.infinity, 
              child: tabs[tabIndex]
            ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
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
        ),
        Expanded(child: appContainerWidget),
      ]
    );
  }
}