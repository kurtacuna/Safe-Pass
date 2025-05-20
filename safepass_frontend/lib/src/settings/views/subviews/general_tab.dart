import "package:flutter/material.dart";
import "package:safepass_frontend/common/const/app_theme/app_text_styles.dart";
import "package:safepass_frontend/common/const/kconstants.dart";
import "package:safepass_frontend/common/widgets/app_dropdownbuttonformfield_widget.dart";
import "package:safepass_frontend/common/widgets/app_switch_widget.dart";
import "package:safepass_frontend/src/settings/models/settings_model.dart";

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  // TODO: change values once backend is done
  Security securitySettings = Security(
    enableMultiFactorAuth: true, 
    sessionTimeout: DropdownOption(
      label: "Custom", 
      value: "25"
    ) // in minutes
  );
  Notifications notificationsSettings = Notifications(
    enableVisitorNotifications: true,
    enableAlerts: false,
    enableScheduledReminders: true,
  );
  Visitors visitorsSettings = Visitors(
    maximumVisitorsPerDay: DropdownOption(
      label: "50", 
      value: "50"
    ), 
    maximumVisitDuration: DropdownOption(
      label: "60 min",
      value: "60"
    ) // in minutes
  );
  Exports exportsSettings = Exports(
    exportFormat: DropdownOption(
      label: ".csv",
      value: "csv"
    )
  );
  DropdownOptionsModel sessionTimeoutOptionsModel = DropdownOptionsModel(
    dropdownOptions: [
      DropdownOption(
        label: "30 min", 
        value: "30"
      ),
      DropdownOption(
        label: "60 min", 
        value: "60"
      ),
      DropdownOption(
        label: "90 min", 
        value: "90"
      ),
      DropdownOption(
        label: "120 min", 
        value: "120"
      ),
      DropdownOption(
        label: "Custom", 
        value: "25"
      ),
    ]
  );
  DropdownOptionsModel maximumVisitorsPerDayModel = DropdownOptionsModel(
    dropdownOptions: [
      DropdownOption(
        label: "50 people", 
        value: "50"
      ),
      DropdownOption(
        label: "100 people", 
        value: "100"
      ),
      DropdownOption(
        label: "150 people", 
        value: "150"
      ),
      DropdownOption(
        label: "200 people", 
        value: "200"
      ),
      DropdownOption(
        label: "Custom", 
        value: "25"
      ),
    ]
  );
  DropdownOptionsModel maximumVisitDurationModel = DropdownOptionsModel(
    dropdownOptions: [
      DropdownOption(
        label: "30 min", 
        value: "30"
      ),
      DropdownOption(
        label: "60 min", 
        value: "60"
      ),
      DropdownOption(
        label: "90 min", 
        value: "90"
      ),
      DropdownOption(
        label: "120 min", 
        value: "120"
      ),
      DropdownOption(
        label: "Custom", 
        value: "25"
      ),
    ]
  );
  DropdownOptionsModel exportFormatModel = DropdownOptionsModel(
    dropdownOptions: [
      DropdownOption(
        label: ".csv",
        value: "csv"
      ),
      DropdownOption(
        label: ".xls/.xlsx", 
        value: "xls/xlsx"
      ),
    ]
  );
  // TODO: change values once backend is done


  @override
  Widget build(BuildContext context) {
    final TextEditingController sessionTimeoutController = TextEditingController(
      text: securitySettings.sessionTimeout.value
    );
    final TextEditingController maximumVisitorsPerDayController = TextEditingController(
      text: visitorsSettings.maximumVisitorsPerDay.value
    );
    final TextEditingController maximumVisitDurationController = TextEditingController(
      text: visitorsSettings.maximumVisitDuration.value
    );
    
    return Padding(
      padding: AppConstants.kAppPadding,
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security
            GeneralSettingsGroup(
              title: "Security", 
              subItems: [
                SubItemWidget(
                  title: "Enable Multi-Factor Authentication", 
                  action: AppSwitchWidget(
                    value: securitySettings.enableMultiFactorAuth,
                  )
                ),
                SubItemWidget(
                  title: "Session Timeout\n(in minutes)", 
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: securitySettings.sessionTimeout, 
                    dropdownOptions: sessionTimeoutOptionsModel.dropdownOptions,
                    inputFieldController: sessionTimeoutController,
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
                    value: notificationsSettings.enableVisitorNotifications
                  )
                ),
                SubItemWidget(
                  title: "Enable Alerts", 
                  action: AppSwitchWidget(
                    value: notificationsSettings.enableAlerts
                  )
                ),
                SubItemWidget(
                  title: "Enable Scheduled Reminders", 
                  action: AppSwitchWidget(
                    value: notificationsSettings.enableScheduledReminders
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
                  title: "Maximum Visitors Per Day", 
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: visitorsSettings.maximumVisitorsPerDay,
                    dropdownOptions: maximumVisitorsPerDayModel.dropdownOptions,
                    inputFieldController: maximumVisitorsPerDayController,
                  )
                ),
                SubItemWidget(
                  title: "Maximum Visit Duration\n(in minutes)", 
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: visitorsSettings.maximumVisitDuration,
                    dropdownOptions: maximumVisitDurationModel.dropdownOptions,
                    inputFieldController: maximumVisitDurationController,
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
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: exportsSettings.exportFormat,
                    dropdownOptions: exportFormatModel.dropdownOptions,
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
          child: SizedBox(
            width: 800,
            child: Column(
              spacing: 10,
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
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.defaultStyle,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          width: 150,
          child: action
        )
      ],
    );
  }
}