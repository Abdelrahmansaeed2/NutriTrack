import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(message: 'Connection timed out. Please check your internet connection.');
      case DioExceptionType.badResponse:
        return ApiException.fromResponse(e.response);
      case DioExceptionType.connectionError:
        return const ApiException(message: 'No internet connection. Please check your network.');
      default:
        return ApiException(message: e.message ?? 'An unexpected error occurred.');
    }
  }

  factory ApiException.fromResponse(Response? response) {
    if (response == null) {
      return const ApiException(message: 'No response from server.');
    }
    final statusCode = response.statusCode;
    String message;
    try {
      final data = response.data;
      message = data['message'] ?? data['error'] ?? _defaultMessage(statusCode);
    } catch (_) {
      message = _defaultMessage(statusCode);
    }
    return ApiException(message: message, statusCode: statusCode);
  }

  static String _defaultMessage(int? code) {
    switch (code) {
      case 400:
        return 'Invalid request. Please check your inputs.';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 422:
        return 'Validation failed. Please check your inputs.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}
