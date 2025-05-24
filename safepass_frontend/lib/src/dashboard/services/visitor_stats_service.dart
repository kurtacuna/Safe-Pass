import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safepass_frontend/src/dashboard/models/visitor_stats_model.dart';
import 'package:safepass_frontend/common/const/api_constants.dart';

class VisitorStatsService {
  static Future<VisitorStats> getVisitorStats() async {
    try {
      print('Making request to: ${ApiConstants.baseUrl}/api/visitor_logs/stats/'); // Debug print
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/visitor_logs/stats/'),
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