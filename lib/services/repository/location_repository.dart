import 'package:atmabdulbaridanny/constant/app_api_url.dart';
import 'package:atmabdulbaridanny/models/location_models.dart';
import 'package:atmabdulbaridanny/services/api/api_services.dart';
import 'package:atmabdulbaridanny/utils/app_log.dart';

class LocationRepository {
  LocationRepository._privateConstructor();
  static final LocationRepository _instance = LocationRepository._privateConstructor();
  static LocationRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  /// Fetch all divisions
  Future<List<DivisionModel>> getDivisions() async {
    try {
      final response = await _apiServices.getServices(_api.divisions);
      if (response != null && response is List) {
        return response
            .whereType<Map>()
            .map((e) => DivisionModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      errorLog("getDivisions repo error", e);
    }
    return [];
  }

  /// Fetch districts by divisionId
  Future<List<DistrictModel>> getDistricts(int divisionId) async {
    try {
      final response = await _apiServices.getServices(_api.districts(divisionId));
      if (response != null && response is List) {
        return response
            .whereType<Map>()
            .map((e) => DistrictModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      errorLog("getDistricts repo error", e);
    }
    return [];
  }

  /// Fetch upazilas by districtId
  Future<List<UpazilaModel>> getUpazilas(int districtId) async {
    try {
      final response = await _apiServices.getServices(_api.upazilas(districtId));
      if (response != null && response is List) {
        return response
            .whereType<Map>()
            .map((e) => UpazilaModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      errorLog("getUpazilas repo error", e);
    }
    return [];
  }

  /// Fetch unions by upazilaId
  Future<List<UnionModel>> getUnions(int upazilaId) async {
    try {
      final response = await _apiServices.getServices(_api.unions(upazilaId));
      if (response != null && response is List) {
        return response
            .whereType<Map>()
            .map((e) => UnionModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      errorLog("getUnions repo error", e);
    }
    return [];
  }
}
