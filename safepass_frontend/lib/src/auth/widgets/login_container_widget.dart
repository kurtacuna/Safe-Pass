import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/assets/icons.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kglobal_keys.dart';
import 'package:safepass_frontend/common/const/kroutes.dart';
import 'package:safepass_frontend/common/widgets/app_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_container_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_button_widget.dart';
import 'package:safepass_frontend/common/widgets/app_text_form_field_widget.dart';
import 'package:safepass_frontend/src/auth/controller/jwt_notifier.dart';
import 'package:safepass_frontend/src/auth/controller/password_notifier.dart';

class LoginContainerWidget extends StatefulWidget {
  const LoginContainerWidget({super.key});

  @override
  State<LoginContainerWidget> createState() => _LoginContainerWidgetState();
}

class _LoginContainerWidgetState extends State<LoginContainerWidget> {
  bool _checkboxValue = false;
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  late final FocusNode _passwordNode = FocusNode();

  static final GlobalKey<FormState> _loginKey = AppGlobalKeys.login;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainerWidget(
      width: 500, 
      height: 500, 
      child: Padding(
        padding: const EdgeInsets.all(80),
        child: Column(
          children: [
            Form(
              key: _loginKey,
              child: Consumer<PasswordNotifier>(
                builder: (context, passwordNotifier, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormFieldWidget(
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passwordNode);
                        },
                        controller: _email,
                        hintText: "Email Address",
                        validatorText: "Please enter a valid email address",
                        prefixIcon: AppIcons.kEmailIcon,
                      ),
                  
                      SizedBox(height: 30),
                  
                      AppTextFormFieldWidget(
                        obscureText: passwordNotifier.getObscurePassword,
                        controller: _password,
                        focusNode: _passwordNode,
                        hintText: "Password",
                        validatorText: "Please enter a valid password",
                        prefixIcon: AppIcons.kPasswordIcon,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            passwordNotifier.setObscurePassword = !passwordNotifier.getObscurePassword;
                          },
                          child: passwordNotifier.getObscurePassword
                            ? AppIcons.kCloseEyeIcon
                            : AppIcons.kOpenEyeIcon
                        )
                      ),
                  
                      SizedBox(height: 15),
                  
                      AppTextButtonWidget(
                        onPressed: () {
                          setState(() {
                            _checkboxValue = !_checkboxValue;
                          });
                        }, 
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _checkboxValue,
                              activeColor: AppColors.kDarkBlue,
                              onChanged: (value) {
                                setState(() {
                                  _checkboxValue = !_checkboxValue;
                                });
                              }
                            ),
                            
                            SizedBox(width: 10),
                  
                            Text(
                              "Remember my password",
                              style: AppTextStyles.defaultStyle.copyWith(
                                color: AppColors.kDark
                              ),
                            )
                          ],
                        )
                      )
                    ]
                  );
                }
              ),
            ),

            SizedBox(height: 30),

            AppButtonWidget(
              onTap: () {
                // TODO: handle login
                if (_loginKey.currentState!.validate()) {
                  context.read<JwtNotifier>().login(
                    context: context,
                    email: _email.text,
                    password: _password.text
                  );
                }
                // context.go(AppRoutes.kEntrypoint);
              },
              text: "Log In"
            ),

            SizedBox(height: 10),
            
            AppTextButtonWidget(
              onPressed: () {
                // TODO: handle forgot password
              }, 
              child: Text.rich(
                TextSpan(
                  text: "Forgot Password?",
                  style: AppTextStyles.defaultStyle.copyWith(
                   color: AppColors.kDarkGray,
                    decoration: TextDecoration.underline
                  )
                )
              )
            )
          ],
        ),
      )
    );
  }
}