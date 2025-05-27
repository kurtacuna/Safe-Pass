import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/src/dashboard/models/visitor_stats_model.dart';

class VisitorStatsService {
  static Future<VisitorStats?> getVisitorStats(BuildContext context) async {
    try {
      print("Making request to: ${ApiUrls.statsUrl}"); // Debug print
      var client = http.BrowserClient();
      client.withCredentials = true;
      final response = await client.get(
        Uri.parse(ApiUrls.statsUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed JSON data: $data'); // Debug print
        return VisitorStats.fromJson(data);
      } else if (response.statusCode == 401) {
        return null;
      } else {
        print('Error status code: ${response.statusCode}'); // Debug print
        print('Error response: ${response.body}'); // Debug print
        throw Exception('Failed to load visitor statistics');
      }
    } catch (e) {
      print('Exception caught: $e'); // Debug print
      throw Exception('Failed to connect to the server: $e');
    }
  }
} 