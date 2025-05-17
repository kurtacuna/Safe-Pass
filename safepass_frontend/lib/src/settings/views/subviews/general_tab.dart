import "package:flutter/material.dart";
import "package:safepass_frontend/common/const/app_theme/app_text_styles.dart";
import "package:safepass_frontend/common/const/kconstants.dart";
import "package:safepass_frontend/common/widgets/app_dropdownbuttonformfield_widget.dart";
import "package:safepass_frontend/common/widgets/app_switch_widget.dart";

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  bool testBool = false;
  List<String> dropdownValues = [
    "test1",
    "test2",
  ];
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.kAppPadding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security
            GeneralSettingsGroup(
              title: "Security", 
              subItems: [
                SubItemWidget(
                  title: "Enable Multi-Factor Authentication", 
                  action: AppSwitchWidget(
                    value: testBool,
                    onChanged: (value) {
                      setState(() {
                        testBool = !testBool;
                      });
                    },
                  )
                ),
                SubItemWidget(
                  title: "Password Expiration", 
                  action: AppDropdownbuttonformfieldWidget(
                    value: dropdownValues[0], 
                    dropdownValues: dropdownValues, 
                    onChanged: (value) {
                      setState(() {
                        value = value ?? "*FIX* no value provided";
                      });
                    },
                  )
                ),
                SubItemWidget(
                  title: "Session Timeout", 
                  action: AppSwitchWidget(
                    value: testBool,
                    onChanged: (value) {
                      setState(() {
                        testBool = !testBool;
                      });
                    },
                  )
                ),
              ]
            ),
            Divider(),
            // Notifications
            GeneralSettingsGroup(
              title: "Notifications", 
              subItems: [
                SubItemWidget(
                  title: "Enable Visitor Notifications", 
                  action: AppSwitchWidget(
                    value: testBool, 
                    onChanged: (value) {
                      setState(() {
                        testBool = !testBool;
                      });
                    }
                  )
                ),
                SubItemWidget(
                  title: "Enable Alerts", 
                  action: AppSwitchWidget(
                    value: testBool, 
                    onChanged: (value) {
                      setState(() {
                        testBool = !testBool;
                      });
                    }
                  )
                ),
                SubItemWidget(
                  title: "Enable Scheduled Reminders", 
                  action: AppSwitchWidget(
                    value: testBool, 
                    onChanged: (value) {
                      setState(() {
                        testBool = !testBool;
                      });
                    }
                  )
                ),
              ]
            ),
            Divider(),
            // Visitors
            GeneralSettingsGroup(
              title: "Visitors", 
              subItems: [
                SubItemWidget(
                  title: "Max Visitors Per Day", 
                  action: AppDropdownbuttonformfieldWidget(
                    value: dropdownValues[0], 
                    dropdownValues: dropdownValues, 
                    onChanged: (value) {
                      setState(() {
                        value = value ?? "No val provided";
                      });
                    }
                  )
                ),
                SubItemWidget(
                  title: "Maximum Visit Length", 
                  action: AppDropdownbuttonformfieldWidget(
                    value: dropdownValues[0], 
                    dropdownValues: dropdownValues, 
                    onChanged: (value) {
                      setState(() {
                        value = value ?? "No val provided";
                      });
                    }
                  )
                ),
              ]
            ),
            Divider(),
            // Exports
            GeneralSettingsGroup(
              title: "Exports", 
              subItems: [
                SubItemWidget(
                  title: "Export Format", 
                  action: AppDropdownbuttonformfieldWidget(
                    value: dropdownValues[0], 
                    dropdownValues: dropdownValues, 
                    onChanged: (value) {
                      setState(() {
                        value = value ?? "No val provided";
                      });
                    }
                  )
                )
              ]
            )
          ]
        ),
      ),
    );
  }
}

class GeneralSettingsGroup extends StatelessWidget {
  const GeneralSettingsGroup({
    required this.title,
    required this.subItems,
    super.key
  });

  final String title;
  final List<Widget> subItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.biggerStyleBold
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppConstants.kAppPadding.left
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400
            ),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                subItems.length, 
                (index) {
                  return subItems[index];
                }
              )
            ),
          )
        )
      ],
    );
  }
}

class SubItemWidget extends StatelessWidget {
  const SubItemWidget({
    required this.title,
    required this.action,
    super.key
  });

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.defaultStyle
        ),
        SizedBox(
          width: 100,
          child: action
        )
      ],
    );
  }
}