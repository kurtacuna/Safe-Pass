import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/visitor_logs_model.dart';
import '../../utils/storage.dart';
import '../../utils/storage_keys.dart';
import '../../utils/refetch.dart';
import '../../widgets/snackbar_widget.dart';
import 'dart:developer' as developer;
import 'package:safepass_frontend/common/const/kurls.dart';
import 'dart:convert';

class VisitorLogsController with ChangeNotifier {
  bool _isLoading = false;
  int _statusCode = -1;
  List<VisitorLog> _visitorLogs = [];
  String? _error;

  bool get isLoading => _isLoading;
  int get statusCode => _statusCode;
  List<VisitorLog> get visitorLogs => _visitorLogs;
  String? get error => _error;

  Future<void> getVisitorLogs(BuildContext context) async {
    if (_isLoading) return; // Prevent multiple simultaneous calls

    developer.log('Starting to fetch visitor logs');
    _statusCode = -1;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? accessToken = Storage().getString(StorageKeys.accessTokenKey);
      developer.log('Access token: ${accessToken ?? 'No token found'}');

      if (accessToken == null) {
        throw Exception('No access token found. Please log in again.');
      }

      final url = ApiUrls.visitorLogsUrl;
      developer.log('Fetching from URL: $url');

      if (url.contains('ERROR')) {
        throw Exception('Invalid base URL. Check your .env.development file.');
      }

      // Add timeout to the request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          // For debugging, let's try to parse the response manually
          final jsonData = json.decode(response.body);
          developer.log('Parsed JSON: $jsonData');

          _visitorLogs = visitorLogsFromJson(response.body);
          _statusCode = response.statusCode;
          _error = null;
          developer.log('Successfully loaded ${_visitorLogs.length} logs');
        } catch (e) {
          developer.log('Error parsing response: $e');
          _error = 'Failed to parse server response: $e';
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              appErrorSnackBarWidget(
                context: context,
                text: "Error parsing data: $e"
              )
            );
          }
        }
      } else if (response.statusCode == 401) {
        _error = 'Session expired. Please log in again.';
        developer.log('Unauthorized access - token expired or invalid');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            appErrorSnackBarWidget(
              context: context,
              text: "Session expired. Please log in again."
            )
          );
          // Here you might want to navigate to login screen
          // Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        _error = 'Server returned ${response.statusCode}';
        developer.log('Error response: ${response.statusCode} - ${response.body}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            appErrorSnackBarWidget(
              context: context,
              text: "Failed to fetch visitor logs (${response.statusCode})"
            )
          );
        }
      }
    } catch (e) {
      developer.log('Exception in getVisitorLogs:', error: e);
      _error = e.toString();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          appErrorSnackBarWidget(
            context: context,
            text: "Error: $e"
          )
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      developer.log('Finished fetch attempt. Success: ${_error == null}');
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}
