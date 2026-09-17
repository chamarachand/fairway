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
}
