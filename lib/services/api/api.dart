import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppApi {
  final Dio _dio = Dio();

  /////////////////////// singleton setup
  AppApi._internal() {
    _initDio();
  }
  static final AppApi _instance = AppApi._internal();
  static AppApi get instance => _instance;
  factory AppApi() => _instance;

  /////////////////////// object
  final _storage = StorageServices.instance;
  final appRoutes = AppRoutes.instance;

  bool _isRefreshing = false;
  final _refreshCompleter = <Completer<String?>>[];

  void _initDio() {
    _dio.options
      ..baseUrl = AppApiUrl.domain
      ..connectTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..followRedirects = false
      ..validateStatus = (status) => status != null && status < 400;

    _dio.interceptors.addAll([
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
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

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Ensure base URL has host
    if (options.baseUrl.isEmpty) {
      options.baseUrl = AppApiUrl.domain;
    }

    // Ensure path is prefixed with /api if not an absolute URL
    if (!options.path.startsWith('http://') && !options.path.startsWith('https://')) {
      if (!options.path.startsWith('/api') && !options.path.startsWith('api/')) {
        options.path = '/api${options.path.startsWith('/') ? options.path : '/${options.path}'}';
      }
    }

    options.headers['Accept'] = 'application/json';

    // If request data is not FormData, default to application/json
    if (options.data is! FormData) {
      options.contentType ??= Headers.jsonContentType;
    }

    final token = await _storage.getToken();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) async {
    appLog('API error — status: ${error.response?.statusCode} | ${error.message} | ${error.requestOptions.path}');

    if (error.response?.statusCode == 401) {
      final path = error.requestOptions.path;
      // Do not attempt refresh on auth endpoints to prevent infinite loops
      if (path.contains('/login') || path.contains('/refresh') || path.contains('/register')) {
        return handler.next(error);
      }

      try {
        final newToken = await _refreshAccessToken();
        if (newToken != null && newToken.isNotEmpty) {
          // Retry original request with new token
          error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retried = await _dio.fetch(error.requestOptions);
          return handler.resolve(retried);
        }
      } catch (e) {
        errorLog('token refresh failed', e);
      }

      // Refresh failed — logout and redirect
      await _forceLogout();
      return handler.next(error);
    }

    handler.next(error);
  }

  // Mutex-guarded JWT refresh (calls POST /api/refresh with current Bearer token)
  Future<String?> _refreshAccessToken() async {
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshCompleter.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    String? newToken;

    try {
      final currentToken = await _storage.getToken();
      if (currentToken.isEmpty) return null;

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppApiUrl.domain,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $currentToken',
          },
        ),
      );

      final response = await refreshDio.post('/api/refresh');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map && response.data['token'] != null) {
          newToken = response.data['token'].toString();
          await _storage.setToken(newToken);
        }
      }
    } catch (e) {
      errorLog('_refreshAccessToken error', e);
    } finally {
      _isRefreshing = false;
      for (final c in _refreshCompleter) {
        c.complete(newToken);
      }
      _refreshCompleter.clear();
    }

    return newToken;
  }

  // Clear auth header before redirect so it cannot leak
  Future<void> _forceLogout() async {
    _dio.options.headers.remove('Authorization');
    await StorageServices.instance.logout();
    AppRoutes.instance.pushReplacement(AppRoutesKey.instance.splash);
  }
}
