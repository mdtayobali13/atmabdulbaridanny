import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/citizen_request_models.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class CitizenRequestRepository {
  CitizenRequestRepository._privateConstructor();
  static final CitizenRequestRepository _instance = CitizenRequestRepository._privateConstructor();
  static CitizenRequestRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  // ─────────────────────────────────────────────────────────────
  // Public Citizen Submissions
  // ─────────────────────────────────────────────────────────────

  /// Submit a citizen complaint
  Future<CitizenRequestModel?> submitComplaint({
    required String name,
    required String mobile,
    String? email,
    required String type, // 'local' or 'nrb'
    required int divisionId,
    required int districtId,
    required int upazilaId,
    required int unionId,
    String? wardNo,
    String? village,
    String? subject,
    required String message,
  }) async {
    try {
      final body = <String, dynamic>{
        "name": name.trim(),
        "mobile": mobile.trim(),
        if (email != null && email.isNotEmpty) "email": email.trim(),
        "type": type,
        "division_id": divisionId,
        "district_id": districtId,
        "upazila_id": upazilaId,
        "union_id": unionId,
        if (wardNo != null && wardNo.isNotEmpty) "ward_no": wardNo.trim(),
        if (village != null && village.isNotEmpty) "village": village.trim(),
        if (subject != null && subject.isNotEmpty) "subject": subject.trim(),
        "message": message.trim(),
      };

      final response = await _apiServices.postServices(
        url: _api.complaints,
        body: body,
        statusCodeStart: 200,
        statusCodeEnd: 201,
      );

      if (response != null && response is Map && response['data'] != null) {
        return CitizenRequestModel.fromJson(Map<String, dynamic>.from(response['data'] as Map));
      }
    } catch (e) {
      errorLog("submitComplaint repo error", e);
    }
    return null;
  }

  /// Submit an appointment request
  Future<CitizenRequestModel?> submitAppointment({
    required String name,
    required String mobile,
    String? email,
    required String type, // 'local' or 'nrb'
    required int divisionId,
    required int districtId,
    required int upazilaId,
    required int unionId,
    String? wardNo,
    String? village,
    required String subject,
    required String appointmentDate, // e.g. '2026-09-10'
    required String message,
  }) async {
    try {
      final body = <String, dynamic>{
        "name": name.trim(),
        "mobile": mobile.trim(),
        if (email != null && email.isNotEmpty) "email": email.trim(),
        "type": type,
        "division_id": divisionId,
        "district_id": districtId,
        "upazila_id": upazilaId,
        "union_id": unionId,
        if (wardNo != null && wardNo.isNotEmpty) "ward_no": wardNo.trim(),
        if (village != null && village.isNotEmpty) "village": village.trim(),
        "subject": subject.trim(),
        "appointment_date": appointmentDate.trim(),
        "message": message.trim(),
      };

      final response = await _apiServices.postServices(
        url: _api.appointments,
        body: body,
        statusCodeStart: 200,
        statusCodeEnd: 201,
      );

      if (response != null && response is Map && response['data'] != null) {
        return CitizenRequestModel.fromJson(Map<String, dynamic>.from(response['data'] as Map));
      }
    } catch (e) {
      errorLog("submitAppointment repo error", e);
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────
  // Admin Management
  // ─────────────────────────────────────────────────────────────

  /// List citizen requests with optional filter
  Future<List<CitizenRequestModel>> getAdminCitizenRequests({
    CitizenRequestFilter? filter,
  }) async {
    try {
      final response = await _apiServices.getServices(
        _api.adminCitizenRequests,
        queryParameters: filter?.toQueryParameters(),
      );

      if (response != null) {
        dynamic dataList;
        if (response is List) {
          dataList = response;
        } else if (response is Map) {
          dataList = response['data'] ?? response['items'];
        }

        if (dataList is List) {
          return dataList
              .whereType<Map>()
              .map((e) => CitizenRequestModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      errorLog("getAdminCitizenRequests repo error", e);
    }
    return [];
  }

  /// Get single citizen request by id
  Future<CitizenRequestModel?> getAdminCitizenRequestById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.adminCitizenRequestById(id));
      if (response != null && response is Map) {
        final data = response['data'] ?? response;
        if (data is Map) {
          return CitizenRequestModel.fromJson(Map<String, dynamic>.from(data));
        }
      }
    } catch (e) {
      errorLog("getAdminCitizenRequestById repo error", e);
    }
    return null;
  }

  /// Update citizen request status: 'pending', 'processing', 'approved', 'rejected', 'completed'
  Future<bool> updateCitizenRequestStatus(int id, String status) async {
    try {
      final response = await _apiServices.patchServices(
        url: _api.adminCitizenRequestStatus(id),
        body: {'status': status},
      );
      return response != null;
    } catch (e) {
      errorLog("updateCitizenRequestStatus repo error", e);
      return false;
    }
  }

  /// Delete citizen request
  Future<bool> deleteCitizenRequest(int id) async {
    try {
      final response = await _apiServices.deleteServices(
        url: _api.adminCitizenRequestById(id),
      );
      return response != null;
    } catch (e) {
      errorLog("deleteCitizenRequest repo error", e);
      return false;
    }
  }
}
