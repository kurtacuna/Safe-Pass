import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/src/auth/models/jwt_model.dart';

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
    print("JwtNotifier: Starting login"); // Debug print
    toggleLoading();
    int statusCode = -1;
    notifyListeners();

    // TODO: encrypt data
    try {
      var url = Uri.parse(ApiUrls.jwtCreateUrl);
      print("JwtNotifier: Making API call to ${url}"); // Debug print
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
            'email': email,
            'password': password
          }
        )
      );

      print("JwtNotifier: Response status code: ${response.statusCode}"); // Debug print
      print("JwtNotifier: Response body: ${response.body}"); // Debug print

      if (response.statusCode == 200) {
        // JwtModel model = jwtModelFromJson(response.body);
        
        statusCode = 200;
        // TODO: save tokens to local storage
      } else {
        if (context.mounted) {
          // TODO: check if final
          CommonJsonModel model = commonJsonModelFromJson(response.body);
          print("JwtNotifier: Error message: ${model.detail}"); // Debug print
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(model.detail))
          );
        }
      }
      


    } catch (e) {
      print("JwtNotifier: Error during login:"); // Debug print
      print(e);
    } finally {
      toggleLoading();
    }

    print("JwtNotifier: Returning status code: $statusCode"); // Debug print
    return statusCode;
  }
  // TODO: create register function
}