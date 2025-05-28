import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/registration/models/id_types_model.dart';
import 'package:http/browser_client.dart' as http;

class IdTypesController with ChangeNotifier {
   bool _isLoading = false;
  get getIsLoading => _isLoading;

  List<IdType> _idTypes = [];
  List<IdType> get getIdTypes => _idTypes;

  Future<void> fetchIdTypes(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.idTypesUrl);
      var response = await client.get(url);

      if (response.statusCode == 200) {
        IdTypesModel model = idTypesModelFromJson(response.body);
        _idTypes = model.idTypes;
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => fetchIdTypes(context));
        }
      } else {
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
      print("EssentialDataNotifier:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    } 
  }
}