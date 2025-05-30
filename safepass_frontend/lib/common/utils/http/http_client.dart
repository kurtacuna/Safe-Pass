import 'package:http/http.dart' show Response;
import 'package:http/browser_client.dart' as http;

class HttpClient {
  final _client = http.BrowserClient()..withCredentials = true;

  Future<Response> get(String url) async {
    return await _client.get(Uri.parse(url));
  }

  Future<Response> post(String url, {dynamic body, Map<String, String>? headers}) async {
    return await _client.post(
      Uri.parse(url),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    );
  }
} 