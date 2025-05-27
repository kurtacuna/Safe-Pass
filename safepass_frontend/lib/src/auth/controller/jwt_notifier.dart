import 'dart:convert';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:http/browser_client.dart' as http;

class JwtNotifier with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  void toggleLoading() {
    _isLoading =! _isLoading;
    notifyListeners();
  }

  Future<int> login({
    required BuildContext context,
    required String email,
    required String password
  }) async {
    toggleLoading();
    int statusCode = -1;

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.jwtLogin);
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'credentials': {
            'email': email,
            'password': password
          }
        })
      );
    
      CommonJsonModel model = commonJsonModelFromJson(response.body);
      if (response.statusCode == 200) {
        statusCode = 200;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kLightGreen,
            )
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkRed,
            )
          );
        }
      }

    } catch (e) {
      print("JwtNotifier: Error during login:"); // Debug print
      print(e);
    } finally {
      toggleLoading();
    }

    return statusCode;
  }
}