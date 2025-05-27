class ApiUrls {
  // Base URL for the API
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Django backend URL

  // Authentication endpoints
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';

  // Visitor endpoints
  static const String registerVisitor = '$baseUrl/visitor_details/visitor-registration/';
  static const String checkInVisitor = '$baseUrl/visitor_logs/check-in';
  static const String checkOutVisitor = '$baseUrl/visitor_logs/check-out';
  static const String getVisitorDetails = '$baseUrl/visitor_details/details';
  static const String getVisitorHistory = '$baseUrl/visitor_logs/history';
  static const String visitPurposes = '$baseUrl/visitor_logs/visit-purposes';

  // Face Recognition endpoints
  static const String scanFace = '$baseUrl/face/scan';
  static const String verifyFace = '$baseUrl/face/verify';
  static const String registerFace = '$baseUrl/face/register';
} 