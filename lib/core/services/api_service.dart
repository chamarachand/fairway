import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.https(ApiConstants.baseUrl, path, queryParameters);
    if (kDebugMode) debugPrint('url: ${uri.toString()}');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Server error: ${response.statusCode}');
        throw const ServerException();
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException(
        'Connection timed out. Please check your internet speed',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  Future<dynamic> delete(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.https(ApiConstants.baseUrl, path, queryParameters);
    if (kDebugMode) debugPrint('url: ${uri.toString()}');

    try {
      final response = await http
          .delete(uri)
          .timeout(const Duration(seconds: 10));
      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      } else {
        debugPrint('Server error: ${response.statusCode}');
        throw const ServerException();
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException(
        'Connection timed out. Please check your internet speed',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    final uri = Uri.https(ApiConstants.baseUrl, path, queryParameters);
    if (kDebugMode) debugPrint('url: ${uri.toString()}');
    if (kDebugMode) debugPrint('body: $data');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: data != null ? jsonEncode(data) : null,
          )
          .timeout(const Duration(seconds: 10));

      final statusCode = response.statusCode;

      if (kDebugMode) debugPrint('response: ${response.statusCode}');

      if (statusCode >= 200 && statusCode < 300) {
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      } else {
        debugPrint('Server error: ${response.statusCode}');
        throw const ServerException();
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException(
        'Connection timed out. Please check your internet speed',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }
}
