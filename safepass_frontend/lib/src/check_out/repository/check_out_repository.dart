import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safepass_frontend/common/const/api_endpoints.dart';
import 'package:safepass_frontend/src/check_out/model/visitor_search_result.dart';

class CheckOutRepository {
  final http.Client _client;

  CheckOutRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<VisitorSearchResult>> searchVisitors(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiEndpoints.baseUrl}/visitors/search?query=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => VisitorSearchResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search visitors');
      }
    } catch (e) {
      throw Exception('Failed to search visitors: $e');
    }
  }

  Future<VisitorSearchResult> getVisitorDetails(String visitorId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiEndpoints.baseUrl}/visitors/$visitorId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return VisitorSearchResult.fromJson(json);
      } else {
        throw Exception('Failed to get visitor details');
      }
    } catch (e) {
      throw Exception('Failed to get visitor details: $e');
    }
  }
} 