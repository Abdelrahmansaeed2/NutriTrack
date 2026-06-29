import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "https://nutritrack-backend-blond.vercel.app";

  Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint, String token) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: _getHeaders(token));
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body, String token) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
  }
}