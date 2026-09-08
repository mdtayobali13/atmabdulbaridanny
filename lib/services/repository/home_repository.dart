import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/home_data_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class HomeRepository {
  HomeRepository._privateConstructor();
  static final HomeRepository _instance = HomeRepository._privateConstructor();
  static HomeRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  /// Fetch complete home data (News, Life, Slider, Blog, GalleryCategory, VideoGallery, ResourceContent, AboutMe)
  Future<HomeDataModel?> getHomeData() async {
    try {
      final response = await _apiServices.getServices(_api.home);
      if (response != null && response is Map) {
        return HomeDataModel.fromJson(Map<String, dynamic>.from(response));
      }
    } catch (e) {
      errorLog("getHomeData repo error", e);
    }
    return null;
  }

  /// Record a page visit (e.g. path: '/home')
  Future<Map<String, dynamic>?> recordVisit(String path) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.visit,
        body: {'path': path},
      );
      if (response != null && response is Map) {
        return Map<String, dynamic>.from(response);
      }
    } catch (e) {
      errorLog("recordVisit repo error", e);
    }
    return null;
  }

  /// Get visit stats for a path
  Future<Map<String, dynamic>?> getVisitStats(String path) async {
    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final response = await _apiServices.getServices(_api.visitStats(cleanPath));
      if (response != null && response is Map) {
        return Map<String, dynamic>.from(response);
      }
    } catch (e) {
      errorLog("getVisitStats repo error", e);
    }
    return null;
  }
}
