import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/check_out/model/visitor_search_result.dart';
import 'package:universal_html/html.dart' as html;

class CheckOutController with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  
  List<VisitorSearchResult> _searchResults = [];
  List<VisitorSearchResult> get getSearchResults => _searchResults;

  VisitorSearchResult? _selectedVisitor;
  VisitorSearchResult? get getSelectedVisitor => _selectedVisitor;

  void setSelectedVisitor(VisitorSearchResult? visitor) {
    _selectedVisitor = visitor;
    notifyListeners();
  }

  String? _getCsrfToken() {
    final cookies = html.document.cookie?.split(';');
    if (cookies != null) {
      for (var cookie in cookies) {
        final parts = cookie.trim().split('=');
        if (parts[0] == 'csrftoken') {
          return parts[1];
        }
      }
    }
    return null;
  }
  
  Future<void> searchVisitors(BuildContext context, String query) async {
    print('DEBUG: Starting searchVisitors with query: $query');
    if (query.isEmpty) {
      print('DEBUG: Empty query, clearing results');
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('DEBUG: Making HTTP request to search visitors');
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse('${ApiUrls.visitorCheckOutSearchUrl}?query=$query');
      print('DEBUG: Search URL: $url');
      
      var response = await client.get(url);
      print('DEBUG: Search response status: ${response.statusCode}');
      print('DEBUG: Search response body: ${response.body}');

      if (response.statusCode == 200) {
        VisitorSearchModel model = visitorSearchModelFromJson(response.body);
        _searchResults = model.results;
        print('DEBUG: Found ${_searchResults.length} results');
        print('DEBUG: Search results: ${_searchResults.map((r) => r.toString()).toList()}');
      } else if (response.statusCode == 401) {
        print('DEBUG: Unauthorized, attempting to refresh token');
        if (context.mounted) {
          await refetch(context, fetch: () => searchVisitors(context, query));
        }
      } else {
        print('DEBUG: Error response received');
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
      print("ERROR in CheckOutController searchVisitors:");
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
      
      var url = Uri.parse(ApiUrls.visitorCheckOutUrl);
      print('Check-out URL: $url');

      final csrfToken = _getCsrfToken();
      if (csrfToken == null) {
        throw Exception('CSRF token not found');
      }
      
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
        },
        body: json.encode({
          'visitor_id': visitorId,
        }),
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
          // Clear selection after successful check-out
          setSelectedVisitor(null);
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