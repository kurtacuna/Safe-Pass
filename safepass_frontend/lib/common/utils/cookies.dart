import 'package:web/web.dart' as web;

class AppCookies {
  static List<Map<String, dynamic>> getCookies() {
    String cookies = web.document.cookie;
    List<String> allCookies = cookies.split('; ');
    List<List<String>>  unseparatedCookies = allCookies.map((e) => e.split('=')).toList();
    List<Map<String, dynamic>> kvpCookies = unseparatedCookies.map((e) => {e[0]: e[1]}).toList();
    return kvpCookies;
  } 

   static String getCSRFToken() {
    List<Map<String, dynamic>> cookies = getCookies();
    Map<String, dynamic> csrfToken = cookies.firstWhere(
      (element) => element.containsKey('csrftoken')
    );

    if (csrfToken.containsKey('csrftoken')) {
      return csrfToken['csrftoken'];
    } else {
      // TODO: throw error
      return "No csrftoken found";
    }
  }
}