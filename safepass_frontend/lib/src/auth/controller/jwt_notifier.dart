import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:safepass_frontend/common/const/kurls.dart';

class JwtNotifier with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  void toggleLoading() {
    _isLoading = !_isLoading;
    // notifyListeners();
  }
  final Dio dio = Dio();
  final CookieJar cookieJar = CookieJar(); // Store cookies

  JwtNotifier() {
    dio.interceptors.add(CookieManager(cookieJar)); // Attach Cookie Manager
  }

  Future<int> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    toggleLoading();
    int statusCode = -1;

    try {
      var response = await dio.post(
        ApiUrls.jwtLogin,
        data: {
          "credentials": {
            'email': email,
            'password': password
          }
        },
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      print("debug: headers -> ${response.headers.map}");
      
      // ✅ Store cookies
      var cookies = cookieJar.loadForRequest(Uri.parse(ApiUrls.jwtLogin));
      print("Saved Cookies: $cookies");

    } catch (e) {
      print("JwtNotifier Error");
      print(e);
    } finally {
      toggleLoading();
    }

    return statusCode;
  }
}
