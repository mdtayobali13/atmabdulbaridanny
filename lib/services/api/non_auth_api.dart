import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:atmabdulbaridanny/constant/app_api_url.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NonAuthApi {
  final Dio _dio = Dio();

  NonAuthApi._internal() {
    _initDio();
  }
  static final NonAuthApi _instance = NonAuthApi._internal();
  static NonAuthApi get instance => _instance;
  factory NonAuthApi() => _instance;

  void _initDio() {
    _dio.options
      ..baseUrl = AppApiUrl.domain
      ..connectTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..followRedirects = false
      ..headers['Accept'] = 'application/json'
      ..contentType = 'application/json';

    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.baseUrl.isEmpty) {
            options.baseUrl = AppApiUrl.domain;
          }
          if (!options.path.startsWith('http://') && !options.path.startsWith('https://')) {
            if (!options.path.startsWith('/api') && !options.path.startsWith('api/')) {
              options.path = '/api${options.path.startsWith('/') ? options.path : '/${options.path}'}';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) => handler.next(error),
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
    ]);
  }

  Dio get sendRequest => _dio;
}
