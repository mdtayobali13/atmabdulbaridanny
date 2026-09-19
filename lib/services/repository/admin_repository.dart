import 'dart:io';
import 'package:dio/dio.dart';
import 'package:barristerkayserkamal/constant/app_api_url.dart';
import 'package:barristerkayserkamal/models/admin_dashboard_model.dart';
import 'package:barristerkayserkamal/models/auth_user_model.dart';
import 'package:barristerkayserkamal/models/citizen_request_models.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/models/location_models.dart';
import 'package:barristerkayserkamal/services/api/api_services.dart';
import 'package:barristerkayserkamal/services/repository/citizen_request_repository.dart';
import 'package:barristerkayserkamal/services/storage/storage_services.dart';
import 'package:barristerkayserkamal/utils/app_log.dart';

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
      final token = await StorageServices.instance.getToken();
      if (token.isEmpty) return null;
      final response = await _apiServices.getServices(_api.dashboard);
      Map<String, dynamic> map = {};
      if (response != null && response is Map && response['data'] is Map) {
        map = Map<String, dynamic>.from(response['data'] as Map);
      }

      // Concurrently fetch supplementary counts for all 17 modules
      try {
        final results = await Future.wait([
          _apiServices.getServices(_api.slider).catchError((_) => null),
          _apiServices.getServices(_api.aboutMe).catchError((_) => null),
          _apiServices.getServices(_api.news).catchError((_) => null),
          _apiServices.getServices(_api.blog).catchError((_) => null),
          _apiServices.getServices(_api.developmentWorkContent).catchError((_) => null),
          CitizenRequestRepository.instance.getAdminCitizenRequests().catchError((_) => <CitizenRequestModel>[]),
          _apiServices.getServices(_api.footerLink).catchError((_) => null),
          _apiServices.getServices(_api.websiteSetting).catchError((_) => null),
        ]);

        int extractCount(dynamic res) {
          if (res == null) return 0;
          if (res is List) return res.length;
          if (res is Map) {
            if (res['data'] is List) return (res['data'] as List).length;
            if (res['data'] is Map) return 1;
            if (res['count'] is int) return res['count'] as int;
            return 1;
          }
          return 0;
        }

        if (!map.containsKey('slider') || map['slider'] == null) {
          map['slider'] = extractCount(results[0]);
        }
        if (!map.containsKey('about_me') || map['about_me'] == null) {
          map['about_me'] = extractCount(results[1]);
        }
        if (!map.containsKey('news') || map['news'] == null) {
          map['news'] = extractCount(results[2]);
        }
        if (!map.containsKey('blog') || map['blog'] == null) {
          map['blog'] = extractCount(results[3]);
        }
        if (!map.containsKey('development_work') || map['development_work'] == null) {
          map['development_work'] = extractCount(results[4]);
        }

        final requests = results[5];
        if (requests is List<CitizenRequestModel>) {
          final complaints = requests.where((r) => (r.requestType ?? '').toLowerCase() == 'complaint').length;
          final appts = requests.where((r) => (r.requestType ?? '').toLowerCase() != 'complaint').length;
          if (!map.containsKey('complaints') || map['complaints'] == null) {
            map['complaints'] = complaints;
          }
          if (!map.containsKey('appointments') || map['appointments'] == null) {
            map['appointments'] = appts;
          }
        }

        if (!map.containsKey('website_setting') || map['website_setting'] == null) {
          final flCount = extractCount(results[6]);
          final wsCount = extractCount(results[7]);
          map['website_setting'] = (flCount + wsCount) > 0 ? (flCount + wsCount) : 1;
        }
      } catch (e) {
        errorLog("supplementary dashboard counts error", e);
      }

      return AdminDashboardModel.fromJson(map);
    } catch (e) {
      errorLog("getDashboard repo error", e);
    }
    return null;
  }

  Future<List<String>> getPermissions() async {
    try {
      final token = await StorageServices.instance.getToken();
      if (token.isEmpty) return [];
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
      final token = await StorageServices.instance.getToken();
      if (token.isEmpty) return [];
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

  // ─────────────────────────────────────────────────────────────
  // 5. Contact List & Delete
  // ─────────────────────────────────────────────────────────────
  Future<List<ContactMessageModel>> getContactList() async {
    try {
      var response = await _apiServices.getServices(_api.appointmentContact);
      dynamic dataList;
      if (response != null) {
        if (response is List) {
          dataList = response;
        } else if (response is Map) {
          dataList = response['data'] ?? response['items'] ?? response['contacts'];
        }
      }

      if (dataList == null) {
        response = await _apiServices.getServices(_api.appointment, queryParameters: {'type': 'contact'});
        if (response != null) {
          if (response is List) {
            dataList = response;
          } else if (response is Map) {
            dataList = response['data'] ?? response['items'];
          }
        }
      }

      if (dataList is List) {
        return dataList
            .whereType<Map>()
            .map((e) => ContactMessageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      errorLog("getContactList error", e);
    }
    return [];
  }

  Future<bool> deleteContact(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: _api.appointmentById(id));
      return response != null;
    } catch (e) {
      errorLog("deleteContact error", e);
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 6. About Me CRUD
  // ─────────────────────────────────────────────────────────────
  Future<List<AboutMeModel>> getAboutMeList() async {
    try {
      final response = await _apiServices.getServices(_api.aboutMe);
      dynamic dataList = response;
      if (response != null && response is Map) {
        dataList = response['data'] ?? response['items'] ?? response['about_me'];
      }
      if (dataList is List) {
        return dataList
            .whereType<Map>()
            .map((e) => AboutMeModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (response is Map && (response.containsKey('id') || (response['data'] is Map))) {
        final itemMap = response['data'] is Map ? response['data'] : response;
        return [AboutMeModel.fromJson(Map<String, dynamic>.from(itemMap))];
      }
    } catch (e) {
      errorLog("getAboutMeList error", e);
    }
    return [];
  }

  Future<bool> createAboutMe({
    required String contentEn,
    required String contentBn,
    String? filePath,
  }) async {
    try {
      final Map<String, dynamic> map = {
        'content_en': contentEn.trim(),
        'content_bn': contentBn.trim(),
      };
      if (filePath != null && filePath.isNotEmpty) {
        final fileName = filePath.split(Platform.pathSeparator).last;
        map['file'] = await MultipartFile.fromFile(filePath, filename: fileName);
      }
      final formData = FormData.fromMap(map);
      return await createResource(_api.aboutMe, formData);
    } catch (e) {
      errorLog("createAboutMe error", e);
      return false;
    }
  }

  Future<bool> updateAboutMe({
    required int id,
    required String contentEn,
    required String contentBn,
    String? filePath,
  }) async {
    try {
      final Map<String, dynamic> map = {
        'content_en': contentEn.trim(),
        'content_bn': contentBn.trim(),
      };
      if (filePath != null && filePath.isNotEmpty) {
        final fileName = filePath.split(Platform.pathSeparator).last;
        map['file'] = await MultipartFile.fromFile(filePath, filename: fileName);
        final formData = FormData.fromMap(map);
        return await updateResourceWithFile(_api.aboutMeById(id), formData);
      } else {
        return await updateResourceJson(_api.aboutMeById(id), map);
      }
    } catch (e) {
      errorLog("updateAboutMe error", e);
      return false;
    }
  }

  Future<bool> deleteAboutMe(int id) async {
    try {
      return await deleteResource(_api.aboutMeById(id));
    } catch (e) {
      errorLog("deleteAboutMe error", e);
      return false;
    }
  }
}

