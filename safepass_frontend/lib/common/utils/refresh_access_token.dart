import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';


Future<void> refetch(BuildContext context, {
  required Function() fetch,
}) async {
  int status = await refreshAccessToken(context);

  if (status == -1) {
    // TODO: Log out the user
    print('session expired');
  } else {
    await fetch();
  }

  return;
}

Future<int> refreshAccessToken(BuildContext context) async {
  int statusCode = -1;

  try {
    var client = http.BrowserClient();
    client.withCredentials = true;
    var url = Uri.parse(ApiUrls.jwtRefreshUrl);
    var response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      statusCode = response.statusCode;
    } else if (response.statusCode == 401) {
      if (context.mounted) {
        CommonJsonModel model = commonJsonModelFromJson(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(model.detail),
            backgroundColor: AppColors.kDarkRed,
          )
        );
      }
    } else {
      print("refreshAccessToken:");
      print(response.body);
    }

  } catch (e) {
    print("refreshAccessToken:");
    print(e);
  }

  return statusCode;
}