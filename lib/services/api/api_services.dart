import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:atmabdulbaridanny/routes/app_routes.dart';
import 'package:atmabdulbaridanny/services/api/api.dart';
import 'package:atmabdulbaridanny/services/storage/storage_services.dart';
import 'package:atmabdulbaridanny/utils/app_log.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';

class ApiServices {
  ApiServices._privateConstructor();
  static final ApiServices _instance = ApiServices._privateConstructor();
  static ApiServices get instance => _instance;

  final api = AppApi.instance;
  final storageServices = StorageServices.instance;
  final appRoutes = AppRoutes.instance;

  String _extractErrorMessage(dynamic data) {
    if (data == null) return "An unexpected error occurred.";
    if (data is Map) {
      if (data["message"] != null && data["message"].toString().isNotEmpty) {
        return data["message"].toString();
      }
      final err = data["error"] ?? data["errors"];
      if (err != null) {
        if (err is String) return err;
        if (err is Map) {
          final firstKey = err.keys.firstOrNull;
          if (firstKey != null) {
            final val = err[firstKey];
            if (val is List && val.isNotEmpty) return val.first.toString();
            return val.toString();
          }
        }
      }
    }
    return "Request failed.";
  }

  void _handleDioException(DioException e) {
    if (e.response != null) {
      final msg = _extractErrorMessage(e.response?.data);
      if (msg.isNotEmpty && msg != "Request failed.") {
        AppSnackBar.instance.error(msg);
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      AppSnackBar.instance.error("Connection timed out. Please try again.");
    } else if (e.error is SocketException) {
      AppSnackBar.instance.error("Check Your Internet Connection");
    }
    errorLog('ApiServices DioException', e);
  }

  // ─────────────────────────────────────────────────────────────
  // GET Service
  // ─────────────────────────────────────────────────────────────
  Future<dynamic> getServices(
    String url, {
    int statusCode = 200,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.get(
        url,
        queryParameters: queryParameters,
        data: body,
        options: options,
      );
      if (response.statusCode == statusCode || (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)) {
        return response.data;
      }
      return null;
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api timeout exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioException(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // POST Service
  // ─────────────────────────────────────────────────────────────
  Future<dynamic> postServices({
    required String url,
    dynamic body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.post(
        url,
        data: body,
        options: options,
        queryParameters: query,
      );
      if (response.statusCode != null &&
          response.statusCode! >= statusCodeStart &&
          response.statusCode! <= statusCodeEnd) {
        return response.data;
      }
      return null;
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api timeout exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioException(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // PUT Service
  // ─────────────────────────────────────────────────────────────
  Future<dynamic> putServices({
    required String url,
    dynamic body,
    int statusCode = 200,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.put(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );
      if (response.statusCode == statusCode || (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)) {
        return response.data;
      }
      return null;
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api timeout exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioException(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // PATCH Service
  // ─────────────────────────────────────────────────────────────
  Future<dynamic> patchServices({
    required String url,
    Object? body,
    int statusCode = 200,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.patch(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );
      if (response.statusCode == statusCode || (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)) {
        return response.data;
      }
      return null;
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api timeout exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioException(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // DELETE Service
  // ─────────────────────────────────────────────────────────────
  Future<dynamic> deleteServices({
    required String url,
    Object? body,
    int statusCode = 200,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.delete(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );
      if (response.statusCode == statusCode || (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)) {
        return response.data;
      }
      return null;
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api timeout exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioException(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Multipart File Upload / Update Service (supporting _method=PUT)
  // ─────────────────────────────────────────────────────────────
  Future<dynamic> multipartServices({
    required String url,
    required FormData formData,
    bool isUpdateWithPutMethod = false,
  }) async {
    if (isUpdateWithPutMethod) {
      formData.fields.add(const MapEntry('_method', 'PUT'));
    }
    return postServices(
      url: url,
      body: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
