import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "https://nutritrack-backend-blond.vercel.app";

  String? _token;

  set token(String? newToken) {
    _token = newToken;
  }

  String? get token => _token;

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };

    print("--- CURRENT API CLIENT TOKEN: $_token ---");
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: _getHeaders());
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(
      url,
      headers: _getHeaders(),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(url, headers: _getHeaders());
  }
}