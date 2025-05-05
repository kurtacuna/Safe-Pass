import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/utils/routes.dart';
import 'package:safepass_frontend/src/entrypoint/controlleres/sidebar_notifier.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SidebarNotifier()),
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