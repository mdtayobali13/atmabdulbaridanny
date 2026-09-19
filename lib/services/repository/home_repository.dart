import 'package:barristerkayserkamal/constant/app_api_url.dart';
import 'package:barristerkayserkamal/models/home_data_model.dart';
import 'package:barristerkayserkamal/services/api/api_services.dart';
import 'package:barristerkayserkamal/utils/app_log.dart';

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

  final Set<String> _recordedPathsInSession = {};
  final Map<String, Map<String, dynamic>> _cachedVisitStats = {};

  /// Record a page visit (e.g. path: 'home' or 'about-me')
  Future<Map<String, dynamic>?> recordVisit(String path) async {
    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      // If already recorded in this session, return cached stats
      if (_recordedPathsInSession.contains(cleanPath) && _cachedVisitStats.containsKey(cleanPath)) {
        return _cachedVisitStats[cleanPath];
      }

      final getResponse = await _apiServices.getServices(_api.visitStats(cleanPath));
      if (getResponse != null && getResponse is Map) {
        final result = Map<String, dynamic>.from(getResponse);
        _recordedPathsInSession.add(cleanPath);
        _cachedVisitStats[cleanPath] = result;
        return result;
      }
      final response = await _apiServices.postServices(
        url: _api.visit,
        body: {'path': path},
      );
      if (response != null && response is Map) {
        final result = Map<String, dynamic>.from(response);
        _recordedPathsInSession.add(cleanPath);
        _cachedVisitStats[cleanPath] = result;
        return result;
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
