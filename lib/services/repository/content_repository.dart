import 'package:barristerkayserkamal/constant/app_api_url.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/models/gallery_and_media_models.dart';
import 'package:barristerkayserkamal/models/service_and_development_models.dart';
import 'package:barristerkayserkamal/services/api/api_services.dart';
import 'package:barristerkayserkamal/utils/app_log.dart';

class ContentRepository {
  ContentRepository._privateConstructor();
  static final ContentRepository _instance = ContentRepository._privateConstructor();
  static ContentRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  List<T> _extractList<T>(dynamic response, T Function(Map<String, dynamic>) fromJson) {
    if (response == null) return [];
    dynamic raw = response;
    if (response is Map) {
      raw = response['data'] ?? response['items'] ?? response.values.firstWhere((v) => v is List, orElse: () => []);
    }
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Map<String, dynamic>? _extractMap(dynamic response) {
    if (response == null) return null;
    if (response is Map) {
      if (response['data'] is Map) {
        return Map<String, dynamic>.from(response['data'] as Map);
      }
      if (response['data'] is List && (response['data'] as List).isNotEmpty) {
        final first = (response['data'] as List).first;
        if (first is Map) {
          return Map<String, dynamic>.from(first);
        }
      }
      return Map<String, dynamic>.from(response);
    }
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map) {
        return Map<String, dynamic>.from(first);
      }
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────
  // News & Blog
  // ─────────────────────────────────────────────────────────────
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await _apiServices.getServices(_api.news);
      return _extractList(response, (m) => NewsModel.fromJson(m));
    } catch (e) {
      errorLog("getNews repo error", e);
      return [];
    }
  }

  Future<NewsModel?> getNewsById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.newsById(id));
      final map = _extractMap(response);
      return map != null ? NewsModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getNewsById repo error", e);
      return null;
    }
  }

  Future<List<BlogModel>> getBlogs() async {
    try {
      final response = await _apiServices.getServices(_api.blog);
      return _extractList(response, (m) => BlogModel.fromJson(m));
    } catch (e) {
      errorLog("getBlogs repo error", e);
      return [];
    }
  }

  Future<BlogModel?> getBlogById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.blogById(id));
      final map = _extractMap(response);
      return map != null ? BlogModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getBlogById repo error", e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Slider & About Sections
  // ─────────────────────────────────────────────────────────────
  Future<List<SliderModel>> getSliders() async {
    try {
      final response = await _apiServices.getServices(_api.slider);
      return _extractList(response, (m) => SliderModel.fromJson(m));
    } catch (e) {
      errorLog("getSliders repo error", e);
      return [];
    }
  }

  Future<AboutModel?> getAbout() async {
    try {
      final response = await _apiServices.getServices(_api.about);
      final map = _extractMap(response);
      return map != null ? AboutModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getAbout repo error", e);
      return null;
    }
  }

  Future<WebsiteSettingModel?> getWebsiteSetting() async {
    try {
      final response = await _apiServices.getServices(_api.websiteSetting);
      final map = _extractMap(response);
      return map != null ? WebsiteSettingModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getWebsiteSetting repo error", e);
      return null;
    }
  }

  Future<List<BiographyModel>> getBiography() async {
    try {
      final response = await _apiServices.getServices(_api.biography);
      return _extractList(response, (m) => BiographyModel.fromJson(m));
    } catch (e) {
      errorLog("getBiography repo error", e);
      return [];
    }
  }

  Future<List<LifeStruggleModel>> getLifeStruggle() async {
    try {
      final response = await _apiServices.getServices(_api.lifeStruggle);
      return _extractList(response, (m) => LifeStruggleModel.fromJson(m));
    } catch (e) {
      errorLog("getLifeStruggle repo error", e);
      return [];
    }
  }

  Future<AboutMeModel?> getAboutMe() async {
    try {
      final response = await _apiServices.getServices(_api.aboutMe);
      if (response is List && response.isNotEmpty) {
        final first = response.first;
        if (first is Map) {
          return AboutMeModel.fromJson(Map<String, dynamic>.from(first));
        }
      }
      if (response is Map) {
        final dynamic dataList = response['data'] ?? response['AboutMe'] ?? response['items'];
        if (dataList is List && dataList.isNotEmpty) {
          final first = dataList.first;
          if (first is Map) {
            return AboutMeModel.fromJson(Map<String, dynamic>.from(first));
          }
        } else if (dataList is Map) {
          return AboutMeModel.fromJson(Map<String, dynamic>.from(dataList));
        }
      }
      final map = _extractMap(response);
      return map != null ? AboutMeModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getAboutMe repo error", e);
      return null;
    }
  }

  Future<List<FooterLinkModel>> getFooterLinks() async {
    try {
      final response = await _apiServices.getServices(_api.footerLink);
      return _extractList(response, (m) => FooterLinkModel.fromJson(m));
    } catch (e) {
      errorLog("getFooterLinks repo error", e);
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Appointments & Contacts
  // ─────────────────────────────────────────────────────────────
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _apiServices.getServices(_api.appointment);
      return _extractList(response, (m) => AppointmentModel.fromJson(m));
    } catch (e) {
      errorLog("getAppointments repo error", e);
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentContacts() async {
    try {
      final response = await _apiServices.getServices(_api.appointmentContact);
      return _extractList(response, (m) => AppointmentModel.fromJson(m));
    } catch (e) {
      errorLog("getAppointmentContacts repo error", e);
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentAppointments() async {
    try {
      final response = await _apiServices.getServices(_api.appointmentAppointment);
      return _extractList(response, (m) => AppointmentModel.fromJson(m));
    } catch (e) {
      errorLog("getAppointmentAppointments repo error", e);
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Services
  // ─────────────────────────────────────────────────────────────
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _apiServices.getServices(_api.services);
      return _extractList(response, (m) => ServiceModel.fromJson(m));
    } catch (e) {
      errorLog("getServices repo error", e);
      return [];
    }
  }

  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    try {
      final response = await _apiServices.getServices(_api.serviceCategories);
      return _extractList(response, (m) => ServiceCategoryModel.fromJson(m));
    } catch (e) {
      errorLog("getServiceCategories repo error", e);
      return [];
    }
  }

  Future<ServiceCategoryModel?> getCategoryWithServices(int id) async {
    try {
      final response = await _apiServices.getServices(_api.categoryWithServices(id));
      final map = _extractMap(response);
      return map != null ? ServiceCategoryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getCategoryWithServices repo error", e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // About Us
  // ─────────────────────────────────────────────────────────────
  Future<List<AboutUsContentModel>> getAboutUsContent() async {
    try {
      final response = await _apiServices.getServices(_api.aboutUsContent);
      return _extractList(response, (m) => AboutUsContentModel.fromJson(m));
    } catch (e) {
      errorLog("getAboutUsContent repo error", e);
      return [];
    }
  }

  Future<List<AboutUsCategoryModel>> getAboutUsCategories() async {
    try {
      final response = await _apiServices.getServices(_api.aboutUsCategory);
      return _extractList(response, (m) => AboutUsCategoryModel.fromJson(m));
    } catch (e) {
      errorLog("getAboutUsCategories repo error", e);
      return [];
    }
  }

  Future<AboutUsCategoryModel?> getAboutUsCategoryWithContent(int id) async {
    try {
      final response = await _apiServices.getServices(_api.aboutUsCategoryWithContent(id));
      final map = _extractMap(response);
      return map != null ? AboutUsCategoryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getAboutUsCategoryWithContent repo error", e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Development Work
  // ─────────────────────────────────────────────────────────────
  Future<List<DevelopmentWorkContentModel>> getDevelopmentWorkContent() async {
    try {
      final response = await _apiServices.getServices(_api.developmentWorkContent);
      return _extractList(response, (m) => DevelopmentWorkContentModel.fromJson(m));
    } catch (e) {
      errorLog("getDevelopmentWorkContent repo error", e);
      return [];
    }
  }

  Future<List<DevelopmentWorkCategoryModel>> getDevelopmentWorkCategories() async {
    try {
      final response = await _apiServices.getServices(_api.developmentWorkCategory);
      return _extractList(response, (m) => DevelopmentWorkCategoryModel.fromJson(m));
    } catch (e) {
      errorLog("getDevelopmentWorkCategories repo error", e);
      return [];
    }
  }

  Future<DevelopmentWorkCategoryModel?> getDevelopmentWorkCategoryWithContent(int id) async {
    try {
      final response = await _apiServices.getServices(_api.developmentWorkCategoryWithContent(id));
      final map = _extractMap(response);
      return map != null ? DevelopmentWorkCategoryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getDevelopmentWorkCategoryWithContent repo error", e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Resources
  // ─────────────────────────────────────────────────────────────
  Future<List<ResourceContentModel>> getResourceContent() async {
    try {
      final response = await _apiServices.getServices(_api.resourceContent);
      return _extractList(response, (m) => ResourceContentModel.fromJson(m));
    } catch (e) {
      errorLog("getResourceContent repo error", e);
      return [];
    }
  }

  Future<List<ResourceCategoryModel>> getResourceCategories() async {
    try {
      final response = await _apiServices.getServices(_api.resourceCategory);
      return _extractList(response, (m) => ResourceCategoryModel.fromJson(m));
    } catch (e) {
      errorLog("getResourceCategories repo error", e);
      return [];
    }
  }

  Future<ResourceCategoryModel?> getResourceCategoryWithContent(int id) async {
    try {
      final response = await _apiServices.getServices(_api.resourceCategoryWithContent(id));
      final map = _extractMap(response);
      return map != null ? ResourceCategoryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getResourceCategoryWithContent repo error", e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Gallery, Photo, Video, and Electronic Media
  // ─────────────────────────────────────────────────────────────
  Future<List<GalleryCategoryModel>> getGalleryCategories() async {
    try {
      final response = await _apiServices.getServices(_api.galleryCategory);
      return _extractList(response, (m) => GalleryCategoryModel.fromJson(m));
    } catch (e) {
      errorLog("getGalleryCategories repo error", e);
      return [];
    }
  }

  Future<GalleryCategoryModel?> getGalleryCategoryWithContent(int id) async {
    try {
      final response = await _apiServices.getServices(_api.galleryCategoryWithContent(id));
      final map = _extractMap(response);
      return map != null ? GalleryCategoryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getGalleryCategoryWithContent repo error", e);
      return null;
    }
  }

  Future<List<PhotoGalleryModel>> getPhotoGallery() async {
    try {
      final response = await _apiServices.getServices(_api.photoGallery);
      return _extractList(response, (m) => PhotoGalleryModel.fromJson(m));
    } catch (e) {
      errorLog("getPhotoGallery repo error", e);
      return [];
    }
  }

  Future<PhotoGalleryModel?> getPhotoGalleryById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.findPhotoGallery(id));
      final map = _extractMap(response);
      return map != null ? PhotoGalleryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getPhotoGalleryById repo error", e);
      return null;
    }
  }

  Future<List<VideoGalleryModel>> getVideoGallery() async {
    try {
      final response = await _apiServices.getServices(_api.videoGallery);
      return _extractList(response, (m) => VideoGalleryModel.fromJson(m));
    } catch (e) {
      errorLog("getVideoGallery repo error", e);
      return [];
    }
  }

  Future<VideoGalleryModel?> getVideoGalleryById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.findVideoGallery(id));
      final map = _extractMap(response);
      return map != null ? VideoGalleryModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getVideoGalleryById repo error", e);
      return null;
    }
  }

  Future<List<ElectronicMediaModel>> getElectronicMedia() async {
    try {
      final response = await _apiServices.getServices(_api.electronicMedia);
      return _extractList(response, (m) => ElectronicMediaModel.fromJson(m));
    } catch (e) {
      errorLog("getElectronicMedia repo error", e);
      return [];
    }
  }

  Future<ElectronicMediaModel?> getElectronicMediaById(int id) async {
    try {
      final response = await _apiServices.getServices(_api.findElectronicMedia(id));
      final map = _extractMap(response);
      return map != null ? ElectronicMediaModel.fromJson(map) : null;
    } catch (e) {
      errorLog("getElectronicMediaById repo error", e);
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Public Users List
  // ─────────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final response = await _apiServices.getServices(_api.users);
      return _extractList(response, (m) => m);
    } catch (e) {
      errorLog("getUsers repo error", e);
      return [];
    }
  }
}
