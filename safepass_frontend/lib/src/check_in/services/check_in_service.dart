import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/http/http_client.dart';

class CheckInService with ChangeNotifier {
  final HttpClient _httpClient = HttpClient();

  Future<List<Map<String, dynamic>>> searchVisitors(String query) async {
    try {
      final response = await _httpClient.get(
        '${ApiUrls.visitorsUrl}search/?query=$query',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Failed to search visitors');
      }
    } catch (e) {
      print('Error searching visitors: $e');
      throw Exception('Failed to search visitors');
    }
  }

  bool _isLoading = false;
  get getIsLoading => _isLoading;

  Future<Map<String, dynamic>> checkInVisitor({
    required int visitorId,
    required int purposeId,
  }) async {
    _isLoading = true;
    notifyListeners();


    print("debug: sending request to chck in");

    try {
      final response = await _httpClient.post(
        ApiUrls.visitorCheckInUrl,
        body: json.encode({
          'visitor_id': visitorId,
          'purpose_id': purposeId,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check in visitor');
      }
    } catch (e) {
      print('Error checking in visitor: $e');
      throw Exception('Failed to check in visitor');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 