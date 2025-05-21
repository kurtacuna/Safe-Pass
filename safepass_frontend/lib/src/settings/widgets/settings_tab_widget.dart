import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';

class SettingsTabWidget extends StatelessWidget {
  const SettingsTabWidget({
    required this.text,
    required this.index,
    this.width = 200,
    this.height = 50,
    super.key
  });

  final String text;
  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsTabNotifier>(
      builder: (context, settingsTabNotifier, child) {
        return SizedBox(
          width: width,
          height: height,
          child: Material(
            elevation: 20,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: ListTile(
              onTap: () {
                settingsTabNotifier.setTabIndex = index;
              },
              tileColor: AppColors.kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              ),
              selected: settingsTabNotifier.getTabIndex == index
                ? true
                : false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.defaultStyle
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10
              ),
            ),
          ),
        );
      }
    );
  }
}