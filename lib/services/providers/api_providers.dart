import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/models/admin_dashboard_model.dart';
import 'package:barristerkayserkamal/models/auth_user_model.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/models/gallery_and_media_models.dart';
import 'package:barristerkayserkamal/models/home_data_model.dart';
import 'package:barristerkayserkamal/models/location_models.dart';
import 'package:barristerkayserkamal/models/service_and_development_models.dart';
import 'package:barristerkayserkamal/services/repository/admin_repository.dart';
import 'package:barristerkayserkamal/services/repository/auth_repository.dart';
import 'package:barristerkayserkamal/services/repository/content_repository.dart';
import 'package:barristerkayserkamal/services/repository/home_repository.dart';
import 'package:barristerkayserkamal/services/repository/location_repository.dart';

// ─────────────────────────────────────────────────────────────
// Home Provider
// ─────────────────────────────────────────────────────────────
final homeDataProvider = FutureProvider<HomeDataModel?>((ref) async {
  return HomeRepository.instance.getHomeData();
});

final homeVisitStatsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return HomeRepository.instance.getVisitStats('home');
});

// ─────────────────────────────────────────────────────────────
// Content Providers
// ─────────────────────────────────────────────────────────────
final newsListProvider = FutureProvider<List<NewsModel>>((ref) async {
  return ContentRepository.instance.getNews();
});

final newsDetailProvider = FutureProvider.family<NewsModel?, int>((ref, id) async {
  return ContentRepository.instance.getNewsById(id);
});

final blogListProvider = FutureProvider<List<BlogModel>>((ref) async {
  return ContentRepository.instance.getBlogs();
});

final blogDetailProvider = FutureProvider.family<BlogModel?, int>((ref, id) async {
  return ContentRepository.instance.getBlogById(id);
});

final sliderListProvider = FutureProvider<List<SliderModel>>((ref) async {
  return ContentRepository.instance.getSliders();
});

final aboutMeProvider = FutureProvider<AboutMeModel?>((ref) async {
  final aboutMe = await ContentRepository.instance.getAboutMe();
  if (aboutMe != null &&
      ((aboutMe.contentEn?.isNotEmpty ?? false) ||
          (aboutMe.contentBn?.isNotEmpty ?? false))) {
    return aboutMe;
  }
  try {
    final homeData = await ref.watch(homeDataProvider.future);
    if (homeData != null && homeData.aboutMe.isNotEmpty) {
      return homeData.aboutMe.first;
    }
  } catch (_) {}
  return aboutMe;
});

final aboutProvider = FutureProvider<AboutModel?>((ref) async {
  return ContentRepository.instance.getAbout();
});

final biographyListProvider = FutureProvider<List<BiographyModel>>((ref) async {
  return ContentRepository.instance.getBiography();
});

final lifeStruggleListProvider = FutureProvider<List<LifeStruggleModel>>((ref) async {
  return ContentRepository.instance.getLifeStruggle();
});

final websiteSettingProvider = FutureProvider<WebsiteSettingModel?>((ref) async {
  return ContentRepository.instance.getWebsiteSetting();
});

final footerLinksProvider = FutureProvider<List<FooterLinkModel>>((ref) async {
  return ContentRepository.instance.getFooterLinks();
});

// ─────────────────────────────────────────────────────────────
// Services & Development Providers
// ─────────────────────────────────────────────────────────────
final servicesListProvider = FutureProvider<List<ServiceModel>>((ref) async {
  return ContentRepository.instance.getServices();
});

final serviceCategoriesProvider = FutureProvider<List<ServiceCategoryModel>>((ref) async {
  return ContentRepository.instance.getServiceCategories();
});

final developmentWorkContentProvider = FutureProvider<List<DevelopmentWorkContentModel>>((ref) async {
  return ContentRepository.instance.getDevelopmentWorkContent();
});

final developmentWorkCategoriesProvider = FutureProvider<List<DevelopmentWorkCategoryModel>>((ref) async {
  return ContentRepository.instance.getDevelopmentWorkCategories();
});

// ─────────────────────────────────────────────────────────────
// Gallery Providers
// ─────────────────────────────────────────────────────────────
final photoGalleryProvider = FutureProvider<List<PhotoGalleryModel>>((ref) async {
  return ContentRepository.instance.getPhotoGallery();
});

final videoGalleryProvider = FutureProvider<List<VideoGalleryModel>>((ref) async {
  return ContentRepository.instance.getVideoGallery();
});

final electronicMediaProvider = FutureProvider<List<ElectronicMediaModel>>((ref) async {
  return ContentRepository.instance.getElectronicMedia();
});

final galleryCategoriesProvider = FutureProvider<List<GalleryCategoryModel>>((ref) async {
  return ContentRepository.instance.getGalleryCategories();
});

// ─────────────────────────────────────────────────────────────
// Location Cascade Providers
// ─────────────────────────────────────────────────────────────
final divisionsProvider = FutureProvider<List<DivisionModel>>((ref) async {
  return LocationRepository.instance.getDivisions();
});

final districtsProvider = FutureProvider.family<List<DistrictModel>, int>((ref, divisionId) async {
  return LocationRepository.instance.getDistricts(divisionId);
});

final upazilasProvider = FutureProvider.family<List<UpazilaModel>, int>((ref, districtId) async {
  return LocationRepository.instance.getUpazilas(districtId);
});

final unionsProvider = FutureProvider.family<List<UnionModel>, int>((ref, upazilaId) async {
  return LocationRepository.instance.getUnions(upazilaId);
});

// ─────────────────────────────────────────────────────────────
// Auth & Admin Providers
// ─────────────────────────────────────────────────────────────
final currentUserProvider = FutureProvider<AuthUserModel?>((ref) async {
  return AuthRepository.instance.getMe();
});

final permissionsProvider = FutureProvider<List<String>>((ref) async {
  return AdminRepository.instance.getPermissions();
});

final adminDashboardProvider = FutureProvider<AdminDashboardModel?>((ref) async {
  return AdminRepository.instance.getDashboard();
});
