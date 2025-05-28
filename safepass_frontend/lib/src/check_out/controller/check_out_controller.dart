import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/check_out/model/visitor_search_result.dart';

class CheckOutController with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  
  List<VisitorSearchResult> _searchResults = [];
  List<VisitorSearchResult> get getSearchResults => _searchResults;
  
  Future<void> searchVisitors(BuildContext context, String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('Searching for visitors with query: $query');
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse('${ApiUrls.visitorSearchUrl}?query=$query');
      print('Search URL: $url');
      
      var response = await client.get(url);
      print('Search response status: ${response.statusCode}');
      print('Search response body: ${response.body}');

      if (response.statusCode == 200) {
        VisitorSearchModel model = visitorSearchModelFromJson(response.body);
        _searchResults = model.results;
        print('Found ${_searchResults.length} results');
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => searchVisitors(context, query));
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
      print("CheckOutController searchVisitors error:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOutVisitor(BuildContext context, String visitorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Checking out visitor with ID: $visitorId');
      var client = http.BrowserClient();
      client.withCredentials = true;
      
      // Using the visitor logs check-out endpoint
      var url = Uri.parse(ApiUrls.visitorCheckOutUrl);
      print('Check-out URL: $url');
      
      var response = await client.post(
        url,
        body: {
          'visitor_id': visitorId,
        },
      );
      
      print('Check-out response status: ${response.statusCode}');
      print('Check-out response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Visitor successfully checked out!'),
              backgroundColor: AppColors.kLightGreen,
            ),
          );
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => checkOutVisitor(context, visitorId));
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
      print("CheckOutController checkOutVisitor error:");
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking out visitor: $e'),
            backgroundColor: AppColors.kDarkRed,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 