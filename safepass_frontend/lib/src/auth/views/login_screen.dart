import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/const/kroutes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppConstants.kAppPadding,
        child: Stack(
          children: [
            Image.asset(
              AppImages.logoDark,
              height: 50,
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.kEntrypoint);
                    }, 
                    child: Text("Go to Entrypoint")
                  )
                ]
              )
            )
          ],
        )
      )
    );
  }
}