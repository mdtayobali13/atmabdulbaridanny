import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/admin_dashboard_model.dart';
import 'package:flutter_riverpod_template/models/auth_user_model.dart';
import 'package:flutter_riverpod_template/models/location_models.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class AdminRepository {
  AdminRepository._privateConstructor();
  static final AdminRepository _instance = AdminRepository._privateConstructor();
  static AdminRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  // ─────────────────────────────────────────────────────────────
  // 1. Dashboard & Permissions
  // ─────────────────────────────────────────────────────────────
  Future<AdminDashboardModel?> getDashboard() async {
    try {
      final response = await _apiServices.getServices(_api.dashboard);
      if (response != null && response is Map && response['data'] is Map) {
        return AdminDashboardModel.fromJson(Map<String, dynamic>.from(response['data'] as Map));
      }
    } catch (e) {
      errorLog("getDashboard repo error", e);
    }
    return null;
  }

  Future<List<String>> getPermissions() async {
    try {
      final response = await _apiServices.getServices(_api.permissions);
      if (response != null && response is List) {
        return response.map((e) => e.toString()).toList();
      }
    } catch (e) {
      errorLog("getPermissions repo error", e);
    }
    return [];
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Admin Users CRUD
  // ─────────────────────────────────────────────────────────────
  Future<List<AuthUserModel>> getAdminUsers() async {
    try {
      final response = await _apiServices.getServices(_api.adminUsers);
      if (response != null) {
        dynamic dataList = response;
        if (response is Map) dataList = response['data'] ?? response['users'];
        if (dataList is List) {
          return dataList
              .whereType<Map>()
              .map((e) => AuthUserModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      errorLog("getAdminUsers repo error", e);
    }
    return [];
  }

  Future<bool> createAdminUser({
    required String name,
    required String email,
    required String password,
    List<String> permissions = const [],
  }) async {
    try {
      final body = {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        if (permissions.isNotEmpty) 'permissions': permissions,
      };
      final response = await _apiServices.postServices(
        url: _api.adminUsers,
        body: body,
        statusCodeStart: 200,
        statusCodeEnd: 201,
      );
      return response != null;
    } catch (e) {
      errorLog("createAdminUser repo error", e);
      return false;
    }
  }

  Future<AuthUserModel?> getAdminUserById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.adminUserById(id));
      if (response != null && response is Map) {
        final data = response['data'] ?? response;
        if (data is Map) return AuthUserModel.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      errorLog("getAdminUserById repo error", e);
    }
    return null;
  }

  Future<bool> updateAdminUser(int id, Map<String, dynamic> body) async {
    try {
      final response = await _apiServices.putServices(
        url: _api.adminUserById(id),
        body: body,
      );
      return response != null;
    } catch (e) {
      errorLog("updateAdminUser repo error", e);
      return false;
    }
  }

  Future<bool> deleteAdminUser(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: _api.adminUserById(id));
      return response != null;
    } catch (e) {
      errorLog("deleteAdminUser repo error", e);
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Admin Unions CRUD
  // ─────────────────────────────────────────────────────────────
  Future<List<UnionModel>> getUnions({int? upazillaId, String? search, int perPage = 10}) async {
    try {
      final query = <String, dynamic>{'per_page': perPage};
      if (upazillaId != null) query['upazilla_id'] = upazillaId;
      if (search != null && search.isNotEmpty) query['search'] = search;
      final response = await _apiServices.getServices(_api.adminUnions, queryParameters: query);
      if (response != null) {
        dynamic dataList = response;
        if (response is Map) dataList = response['data'] ?? response['items'];
        if (dataList is List) {
          return dataList
              .whereType<Map>()
              .map((e) => UnionModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      errorLog("getUnions repo error", e);
    }
    return [];
  }

  Future<bool> createUnion({
    required int upazillaId,
    required String name,
    String? bnName,
  }) async {
    try {
      final body = {
        'upazilla_id': upazillaId,
        'name': name.trim(),
        if (bnName != null && bnName.isNotEmpty) 'bn_name': bnName.trim(),
      };
      final response = await _apiServices.postServices(
        url: _api.adminUnions,
        body: body,
        statusCodeStart: 200,
        statusCodeEnd: 201,
      );
      return response != null;
    } catch (e) {
      errorLog("createUnion repo error", e);
      return false;
    }
  }

  Future<UnionModel?> getUnionById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.adminUnionById(id));
      if (response != null && response is Map) {
        final data = response['data'] ?? response;
        if (data is Map) return UnionModel.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      errorLog("getUnionById repo error", e);
    }
    return null;
  }

  Future<bool> updateUnion(int id, {required int upazillaId, required String name, String? bnName}) async {
    try {
      final body = {
        'upazilla_id': upazillaId,
        'name': name.trim(),
        if (bnName != null && bnName.isNotEmpty) 'bn_name': bnName.trim(),
      };
      final response = await _apiServices.putServices(
        url: _api.adminUnionById(id),
        body: body,
      );
      return response != null;
    } catch (e) {
      errorLog("updateUnion repo error", e);
      return false;
    }
  }

  Future<bool> deleteUnion(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: _api.adminUnionById(id));
      return response != null;
    } catch (e) {
      errorLog("deleteUnion repo error", e);
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Content CRUD Operations (with multipart and _method=PUT support)
  // ─────────────────────────────────────────────────────────────

  // Generic Create / Store (POST multipart/form-data or JSON)
  Future<bool> createResource(String url, FormData formData) async {
    try {
      final response = await _apiServices.multipartServices(url: url, formData: formData);
      return response != null;
    } catch (e) {
      errorLog("createResource error on $url", e);
      return false;
    }
  }

  // Generic Update with file (uses POST with _method=PUT as required by Laravel)
  Future<bool> updateResourceWithFile(String url, FormData formData) async {
    try {
      final response = await _apiServices.multipartServices(
        url: url,
        formData: formData,
        isUpdateWithPutMethod: true,
      );
      return response != null;
    } catch (e) {
      errorLog("updateResourceWithFile error on $url", e);
      return false;
    }
  }

  // Generic Update JSON (PUT)
  Future<bool> updateResourceJson(String url, Map<String, dynamic> body) async {
    try {
      final response = await _apiServices.putServices(url: url, body: body);
      return response != null;
    } catch (e) {
      errorLog("updateResourceJson error on $url", e);
      return false;
    }
  }

  // Generic Delete (DELETE /{url}/{id})
  Future<bool> deleteResource(String url) async {
    try {
      final response = await _apiServices.deleteServices(url: url);
      return response != null;
    } catch (e) {
      errorLog("deleteResource error on $url", e);
      return false;
    }
  }
}
