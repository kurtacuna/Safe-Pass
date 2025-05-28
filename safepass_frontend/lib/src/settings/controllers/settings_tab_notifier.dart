import 'package:flutter/material.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/settings/models/visitor_details_model.dart';
import 'package:http/browser_client.dart' as http;

class SettingsTabNotifier with ChangeNotifier {
  int _tabIndex = 1;
  int get getTabIndex => _tabIndex;
  set setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  List<Visitor> _visitorDetails = [];
  List<Visitor> get getVisitorDetails => _visitorDetails;
  bool _isLoading = false;
  get getIsLoading => _isLoading;

  Visitor? _visitor;
  Visitor? get getVisitor => _visitor;

  Future<void> fetchVisitors(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.visitorsUrl);
      var response = await client.get(url);

      if (response.statusCode == 200) {
        VisitorsModel model = visitorsModelFromJson(response.body);
        _visitorDetails = model.visitors;
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => fetchVisitors(context));
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
      print("SettingsTabNotifier:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}