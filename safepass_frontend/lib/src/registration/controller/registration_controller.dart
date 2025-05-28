import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/cookies.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/common/utils/widgets/snackbar.dart';
import 'dart:convert';

class VisitorRegistrationNotifier with ChangeNotifier {
  bool _isLoading = false;
  int _statusCode = -1;

  get getIsLoading => _isLoading;
  get getStatusCode => _statusCode;

  Future<void> registerVisitor(
    BuildContext context,
    String firstName,
    String middleName,
    String lastName,
    String idType,
    String idNumber,
    String contactNumber,
  ) async {
    _statusCode = -1;
    _isLoading = true;
    notifyListeners();

    try {
      var url = Uri.parse(ApiUrls.registrationUrl);
      
      print("Registration URL: ${url.toString()}");
      
      var registrationData = {
        "registration_details": {
          "first_name": firstName,
          "middle_name": middleName,
          "last_name": lastName,
          "id_type": idType,
          "id_number": idNumber,
          "contact_number": contactNumber
        }
      };

      print("Registration Data: ${jsonEncode(registrationData)}");

      try {
        var response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": AppCookies.getCSRFToken()
          },
          body: jsonEncode(registrationData)
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          _statusCode = response.statusCode;
          if (context.mounted) {
            AppSnackbar.showSuccess(
              context,
              "Visitor registered successfully"
            );
          }
        } else if (response.statusCode == 401) {
          print("in reg controller response statuscode: ${response.statusCode}");
          if (context.mounted) {
            await refetch(context, fetch: () => registerVisitor(context, firstName, middleName, lastName, idType, idNumber, contactNumber));
          }
          print("in reg controller refetched");
        } else {
          if (context.mounted) {
            Map<String, dynamic> errorResponse = jsonDecode(response.body);
            AppSnackbar.showError(
              context,
              errorResponse['detail'] ?? "Error occurred while registering the visitor"
            );
          }
        }
      } catch (e) {
        print("HTTP Request Error:");
        print(e);
        if (context.mounted) {
          AppSnackbar.showError(
            context,
            "Could not connect to the server. Please make sure the backend server is running."
          );
        }
      }
    } catch (e) {
      print("VisitorRegistrationNotifier Error:");
      print(e);
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          "Error occurred while registering the visitor"
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 