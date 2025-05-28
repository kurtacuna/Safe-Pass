import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static final String _appBaseUrl = dotenv.env["APP_BASE_URL"] ?? "ERROR";
  

  // URLs with trailing slashes are those that require bodies in the request
  // Define your URLs here

  static String jwtLogin = "$_appBaseUrl/auth/login/";
  static String jwtRefreshUrl = "$_appBaseUrl/auth/refresh/";
  static String statsUrl = "$_appBaseUrl/api/visitor_logs/stats/";
  static String visitorLogsUrl = '$_appBaseUrl/api/visitor_logs/visitor_logs/';
  static String registrationUrl = "$_appBaseUrl/api/visitor_details/visitor-registration/";
  static String registerFaceUrl = '$_appBaseUrl/api/visitor_details/register-face/';
  static String verifyFaceUrl = '$_appBaseUrl/api/visitor_details/verify-face/';
  static String visitPurposesUrl = '$_appBaseUrl/api/visitor_logs/purposes/';
  static String visitorsUrl = '$_appBaseUrl/api/visitor_details/visitors/';
  static String idTypesUrl = '$_appBaseUrl/api/visitor_details/id_types/';
  static String visitorSearchUrl = '$_appBaseUrl/api/visitor_details/search/';
  static String visitorCheckInUrl = '$_appBaseUrl/api/visitor_logs/check-in/';
  static const String baseUrl = 'http://localhost:8000/api';
  static const String visitorCheckOutUrl = '$baseUrl/visitors/check-out';
}