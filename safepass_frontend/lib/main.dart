import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/utils/routes.dart';
import 'package:safepass_frontend/src/auth/controller/password_notifier.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SidebarNotifier()),
      ChangeNotifierProvider(create: (_) => PasswordNotifier()),
      ChangeNotifierProvider(create: (_) => SettingsTabNotifier()),
    ],
    child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Safe Pass",
      routerConfig: router,
      theme: ThemeData(
        splashColor: AppColors.kDarkBlue.withValues(
          alpha: 0.2
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: AppColors.kWhite
        ),
        listTileTheme: ListTileThemeData(
          selectedTileColor: AppColors.kDarkBlue.withValues(
            alpha: 0.8
          ),
          selectedColor: AppColors.kWhite
        ),
        scaffoldBackgroundColor: AppColors.kWhite,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.kDarkBlue,
          selectionColor: AppColors.kDarkBlue.withValues(
            alpha: 0.2
          )
        )
      ),
      builder: (context, child) {
        final double width = MediaQuery.sizeOf(context).width;
        final double height = MediaQuery.sizeOf(context).height;
        
        return Scaffold(
          body: Stack(
            children: [
              child!,

              Text(
                "$width x $height",
                style: TextStyle(
                  fontSize: 8,
                  color: AppColors.kDarkGray,
                )
              )
            ]
          )
        );
      },
    );
  }
}