import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static final String _appBaseUrl = dotenv.env["APP_BASE_URL"] ?? "ERROR";

  // URLs with trailing slashes are those that require bodies in the request
  // Define your URLs here

  static String jwtCreateUrl = "$_appBaseUrl/auth/jwt/create/";
  static String jwtRefreshUrl = "$_appBaseUrl/auth/jwt/refresh/";
  
}