import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/cookies.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';
import 'dart:typed_data';

class VisitorDetailsController with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;

  Future<void> uploadPhoto({
    required BuildContext context,
    required Uint8List imageBytes,
    required String imageName,
    required String id
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.updatePhotoUrl);
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: "imagefromclient.jpeg",
          contentType: MediaType('image', 'jpeg')
        )
      );
      request.headers['X-CSRFToken'] = AppCookies.getCSRFToken();
      request.fields['id'] = id;
      
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      CommonJsonModel model = commonJsonModelFromJson(response.body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkBlue,
            )
          );
        }
        if (context.mounted) {
          context.read<SidebarNotifier>().setIndex = 2;
          context.read<SettingsTabNotifier>().setTabIndex = 1;
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => uploadPhoto(context: context, imageBytes: imageBytes, imageName: imageName, id: id));
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
      print("VisitorDetailsController:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVisitorDetails({
    required BuildContext context,
    required String id,
    required String firstName,
    required String middleName,
    required String lastName,
    required String contactNumber,
    required String idType,
    required String idNumber,
    required String status
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.updateVisitorDetailsUrl);
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': AppCookies.getCSRFToken()
        },
        body: jsonEncode({
          "update_details": {
            "id": id,
            "first_name": firstName,
            "middle_name": middleName,
            "last_name": lastName,
            "contact_number": contactNumber,
            "id_type": idType,
            "id_number": idNumber,
            "status": status
          }
        })
      );

      CommonJsonModel model = commonJsonModelFromJson(response.body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkBlue,
            )
          );
          context.read<SidebarNotifier>().setIndex = 2;
          context.read<SettingsTabNotifier>().setTabIndex = 1;
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => updateVisitorDetails(context: context, id: id, firstName: firstName, middleName: middleName, lastName: lastName, contactNumber: contactNumber, idType: idType, idNumber: idNumber, status: status));
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
      print("VisitorDetailsController:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}