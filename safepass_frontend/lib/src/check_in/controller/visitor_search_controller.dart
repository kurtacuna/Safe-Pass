import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:http/http.dart' as normalhttp;
import 'package:http_parser/http_parser.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/check_in/models/visitor_search_model.dart';
import 'package:universal_html/html.dart' as html;

class VisitorSearchController with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  
  List<VisitorSearchResult> _searchResults = [];
  List<VisitorSearchResult> get getSearchResults => _searchResults;

  String? _selectedVisitorId;
  String? get getSelectedVisitorId => _selectedVisitorId;

  VisitorSearchResult? _selectedVisitor;
  VisitorSearchResult? get getSelectedVisitor => _selectedVisitor;

  void setSelectedVisitor(VisitorSearchResult? visitor) {
    _selectedVisitor = visitor;
    _selectedVisitorId = visitor?.id;
    notifyListeners();
  }

  void clearSelectedVisitor() {
    _selectedVisitor = null;
    _selectedVisitorId = null;
    _searchResults = [];
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
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse('${ApiUrls.visitorSearchUrl}?query=$query');
      var response = await client.get(url);

      if (response.statusCode == 200) {
        VisitorSearchModel model = visitorSearchModelFromJson(response.body);
        _searchResults = model.results;
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
      print("VisitorSearchController:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkInVisitor(BuildContext context, {
    required String visitorId,
    required String visitPurpose,
    required var imageBytes,
  }) async {
    _isLoading = true;
    notifyListeners();

    print("debug: inside");

    try {

      print("debug: sent to backend");
      
      final csrfToken = _getCsrfToken();
      if (csrfToken == null) {
        throw Exception('CSRF token not found');
      }

      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.visitorCheckInUrl);
      var request = normalhttp.MultipartRequest('POST', url);
      request.files.add(
        normalhttp.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: "imagefromclient.jpeg",
          contentType: MediaType('image', 'jpeg')
        )
      );

      request.fields['visitor_id'] = visitorId;
      request.fields['visit_purpose'] = visitPurpose;
      request.headers['X-CSRFToken'] = csrfToken;

      var streamedResponse = await client.send(request);
      var response = await normalhttp.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Visitor successfully checked in!'),
              backgroundColor: AppColors.kLightGreen,
            ),
          );
          // Clear selection after successful check-in
          setSelectedVisitor(null);
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => checkInVisitor(
            context,
            visitorId: visitorId,
            visitPurpose: visitPurpose,
            imageBytes: imageBytes
          ));
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
      print("VisitorSearchController checkInVisitor:");
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking in visitor: ${e.toString()}'),
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