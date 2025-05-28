import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/utils/responsive.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';
import 'package:safepass_frontend/src/settings/views/subviews/database_tab.dart';
import 'package:safepass_frontend/src/settings/views/subviews/general_tab.dart';
import 'package:safepass_frontend/src/settings/widgets/settings_tab_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Widget> tabs = [
    GeneralTab(),
    DatabaseTab()
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
    ScrollController tabsHorizontalScrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Scrollbar(
          controller: tabsHorizontalScrollController,
          child: SingleChildScrollView(
            controller: tabsHorizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: MediaQuery.sizeOf(context).height < 150
              ? Container()
              : Row(
                  children: [
                    SettingsTabWidget(
                      text: "General", 
                      index: 0
                    ),
                    SettingsTabWidget(
                      text: "Database", 
                      index: 1
                    ),
                  ]
                ),
          ),
        ),
        Expanded(child: appContainerWidget),
      ]
    );
  }
}