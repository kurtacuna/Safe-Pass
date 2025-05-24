import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';

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
    notifyListeners();

    // TODO: encrypt data
    try {
      var url = Uri.parse(ApiUrls.jwtCreateUrl);
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

      print(response.body);

      if (response.statusCode == 200) {
        statusCode = 200;
        // TODO: save tokens to local storage
      } else {
        if (context.mounted) {
          // TODO: check if final
          CommonJsonModel model = commonJsonModelFromJson(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(model.detail))
          );
        }
      }
      


    } catch (e) {
      print("JwtNotifier");
      print(e);
    } finally {
      toggleLoading();
    }

    return statusCode;
  }
  // TODO: create register function
}