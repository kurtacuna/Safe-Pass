import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/widgets/snackbar.dart';
import 'dart:convert';

class VisitPurposesController with ChangeNotifier {
  bool _isLoading = false;
  int _statusCode = -1;
  List<dynamic> _visitPurposes = [];

  bool get isLoading => _isLoading;
  int get statusCode => _statusCode;
  List<dynamic> get visitPurposes => _visitPurposes;

  // Get all visit purposes
  Future<void> getVisitPurposes(BuildContext context) async {
    _statusCode = -1;
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.visitPurposesUrl);
      var response = await client.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        _visitPurposes = jsonDecode(response.body);
        _statusCode = response.statusCode;
      } else {
        if (context.mounted) {
          Map<String, dynamic> errorResponse = jsonDecode(response.body);
          AppSnackbar.showError(
            context,
            errorResponse['detail'] ?? "Error occurred while fetching visit purposes"
          );
        }
      }
    } catch (e) {
      print("VisitPurposesController Error:");
      print(e);
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          "Could not connect to the server. Please check your connection."
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}