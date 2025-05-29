import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/check_in/models/visit_purposes_model.dart';
import 'dart:convert';

class VisitPurposesController with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  
  List<Purpose> _visitPurposes = [];
  List<Purpose> get getVisitPurposes => _visitPurposes;
  
  Future<void> fetchVisitPurposes(BuildContext context) async {
    print("DEBUG: Starting to fetch visit purposes");
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.visitPurposesUrl);
      print("DEBUG: Fetching from URL: ${url}");
      var response = await client.get(url);
      print("DEBUG: Response status code: ${response.statusCode}");
      print("DEBUG: Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("DEBUG: Parsing response body");
        var jsonData = json.decode(response.body);
        print("DEBUG: Decoded JSON: $jsonData");
        VisitPurposesModel model = visitPurposesModelFromJson(response.body);
        print("DEBUG: Parsed model: $model");
        print("DEBUG: Parsed model purposes: ${model.purposes}");
        _visitPurposes = model.purposes;
        print("DEBUG: Updated visit purposes: $_visitPurposes");
      } else if (response.statusCode == 401) {
        print("DEBUG: Unauthorized, attempting to refresh token");
        if (context.mounted) {
          await refetch(context, fetch: () => fetchVisitPurposes(context));
        }
      } else {
        print("DEBUG: Error response received");
        CommonJsonModel model = commonJsonModelFromJson(response.body);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkRed,
            ),
          );
        }
      }

    } catch (e) {
      print("DEBUG: Error in VisitPurposesController:");
      print(e);
      print("DEBUG: Stack trace:");
      print(StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}