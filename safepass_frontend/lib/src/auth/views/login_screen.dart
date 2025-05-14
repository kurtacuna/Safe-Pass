import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/common/utils/responsive.dart';
import 'package:safepass_frontend/src/auth/widgets/login_container_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Image.asset(
        AppImages.logoDark,
        height: 50,
      ),

      SizedBox(height: 20),

      Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Admin Log-In",
              style: AppTextStyles.biggestPlusStyle.copyWith(
                fontWeight: FontWeight.w900
              )
            ),
      
            SizedBox(height: 15),
      
            // Enter your email and password text
            Text.rich(
              TextSpan(
                style: AppTextStyles.biggerStyle.copyWith(
                  color: AppColors.kGray,
                  fontWeight: FontWeight.w900
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Enter your "
                  ),
                  TextSpan(
                    text: "email",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.kGray
                    )
                  ),
                  TextSpan(
                    text: " and "
                  ),
                  TextSpan(
                    text: "password",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.kGray
                    )
                  )
                ]
              )
            ),
          
            SizedBox(height: 40),

            LoginContainerWidget()
          ]
        )
      )
    ];

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: AppConstants.kAppPadding,
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Center(
              child: AppResponsive(context).responsiveWidget(
                small: Column(
                  children: children,
                ), 
                large: Stack(
                  children: children
                )
              )
            )
          )
        ),
      )
    );
  }
}