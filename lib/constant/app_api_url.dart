import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:barristerkayserkamal/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;

  static const String _defaultDomain = 'https://api.barristerkayserkamal.info';

  static String _validateUrl(String url) {
    if (!kDebugMode && url.startsWith('http://')) {
      errorLog('AppApiUrl', 'HTTP base URL blocked in release build. Use HTTPS.');
      assert(false, 'Production builds must use HTTPS. Got: $url');
    }
    return url;
  }

  static String _cleanDomain(String url) {
    var u = url.trim();
    if (u.endsWith('/api/v1')) {
      u = u.replaceAll(RegExp(r'/api/v1/?$'), '');
    } else if (u.endsWith('/api')) {
      u = u.replaceAll(RegExp(r'/api/?$'), '');
    }
    if (u.endsWith('/')) {
      u = u.substring(0, u.length - 1);
    }
    return u;
  }

  /// Base web domain: `https://api.barristerkayserkamal.info`
  static String get domain {
    const fromDefine = String.fromEnvironment('BASE_DOMAIN');
    if (fromDefine.isNotEmpty) {
      return _validateUrl(_cleanDomain(fromDefine));
    }
    if (dotenv.isInitialized) {
      final envDomain = dotenv.maybeGet('BASE_DOMAIN');
      if (envDomain != null && envDomain.isNotEmpty) {
        return _validateUrl(_cleanDomain(envDomain));
      }
      final envBase = dotenv.maybeGet('BASE_URL');
      if (envBase != null && envBase.isNotEmpty) {
        return _validateUrl(_cleanDomain(envBase));
      }
    }
    return _defaultDomain;
  }

  /// Socket URL
  static String get socket => domain;

  /// API base URL: `https://api.barristerkayserkamal.info/api`
  String get baseUrl => "$domain/api";

  /// Helper to convert relative server image paths (e.g. `assets/file/abc.jpg`) to full URLs
  static String imageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final trimmed = path.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return '$domain/$cleanPath';
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Authentication Endpoints
  // ─────────────────────────────────────────────────────────────
  final String register = "/register";
  final String login = "/login";
  final String logout = "/logout";
  final String refresh = "/refresh";
  final String refreshToken = "/refresh"; // backward compatibility
  final String me = "/me";
  final String resetPassword = "/reset-password";
  String updatePassword(String token) => "/update-password/$token";

  // Legacy auth endpoints kept for backward compatibility
  final String authDeleteAccount = "/authDeleteAccount";
  final String changePassword = "/changePassword";
  final String userResendOtp = "/userResendOtp";
  final String authOtpVerify = "/authOtpVerify";
  final String authForgotPassword = "/reset-password";
  final String authVerifyEmail = "/authVerifyEmail";
  final String authResetPassword = "/authResetPassword";

  // ─────────────────────────────────────────────────────────────
  // 2. Public Content & Tracking Endpoints
  // ─────────────────────────────────────────────────────────────
  final String home = "/home";
  final String visit = "/visit";
  String visitStats(String path) => "/visit/$path";

  // ─────────────────────────────────────────────────────────────
  // 3. Citizen Request Submission
  // ─────────────────────────────────────────────────────────────
  final String complaints = "/complaints";
  final String appointments = "/appointments";

  // ─────────────────────────────────────────────────────────────
  // 4. Location Endpoints (Public)
  // ─────────────────────────────────────────────────────────────
  final String divisions = "/locations/divisions";
  String districts(int divisionId) => "/locations/districts/$divisionId";
  String upazilas(int districtId) => "/locations/upazilas/$districtId";
  String unions(int upazilaId) => "/locations/unions/$upazilaId";

  // ─────────────────────────────────────────────────────────────
  // 5. Public Content Modules (GET) & Admin CRUD
  // ─────────────────────────────────────────────────────────────
  // Slider
  final String slider = "/slider";
  String sliderById(int id) => "/slider/$id";

  // About
  final String about = "/about";
  String aboutById(int id) => "/about/$id";

  // Website Setting
  final String websiteSetting = "/website-setting";
  String websiteSettingById(int id) => "/website-setting/$id";

  // Biography
  final String biography = "/biography";
  String biographyById(int id) => "/biography/$id";

  // Life Struggle
  final String lifeStruggle = "/life-struggle";
  String lifeStruggleById(int id) => "/life-struggle/$id";

  // About Me
  final String aboutMe = "/about-me";
  String aboutMeById(int id) => "/about-me/$id";

  // News
  final String news = "/news";
  String newsById(int id) => "/news/$id";

  // Blog
  final String blog = "/blog";
  String blogById(int id) => "/blog/$id";

  // Footer Link
  final String footerLink = "/footer-link";
  String footerLinkById(int id) => "/footer-link/$id";

  // Appointment & Contact Management
  final String appointment = "/appointment";
  String appointmentById(int id) => "/appointment/$id";
  final String appointmentContact = "/appointment-contact";
  final String appointmentAppointment = "/appointment-appointment";

  // Services Management
  final String services = "/services";
  String servicesById(int id) => "/services/$id";
  final String serviceCategories = "/service_categories";
  String serviceCategoriesById(int id) => "/service_categories/$id";
  String categoryWithServices(int id) => "/category-with-services/$id";

  // About Us Management
  final String aboutUsContent = "/about-us-content";
  String aboutUsContentById(int id) => "/about-us-content/$id";
  final String aboutUsCategory = "/about-us-category";
  String aboutUsCategoryById(int id) => "/about-us-category/$id";
  String aboutUsCategoryWithContent(int id) => "/about-us-category-with-content/$id";

  // Development Work Management
  final String developmentWorkContent = "/development-work-content";
  String developmentWorkContentById(int id) => "/development-work-content/$id";
  final String developmentWorkContentUpdate = "/development-work-content-update";
  final String developmentWorkCategory = "/development-work-category";
  String developmentWorkCategoryById(int id) => "/development-work-category/$id";
  String developmentWorkCategoryWithContent(int id) => "/development-work-category-with-content/$id";

  // Resource Management
  final String resourceContent = "/resource-content";
  String resourceContentById(int id) => "/resource-content/$id";
  final String resourceCategory = "/resource-category";
  String resourceCategoryById(int id) => "/resource-category/$id";
  String resourceCategoryWithContent(int id) => "/resource-category-with-content/$id";

  // Gallery Management
  final String galleryCategory = "/gallery-category";
  String galleryCategoryById(int id) => "/gallery-category/$id";
  String galleryCategoryWithContent(int id) => "/gallery-category-with-content/$id";

  // Photo Gallery
  final String photoGallery = "/photo-gallery";
  final String storePhotoGallery = "/store-photo-gallery";
  String findPhotoGallery(int id) => "/find-photo-gallery/$id";
  String updatePhotoGallery(int id) => "/update-photo-gallery/$id";
  String deletePhotoGallery(int id) => "/delete-photo-gallery/$id";

  // Video Gallery
  final String videoGallery = "/video-gallery";
  final String storeVideoGallery = "/store-video-gallery";
  String findVideoGallery(int id) => "/find-video-gallery/$id";
  String updateVideoGallery(int id) => "/update-video-gallery/$id";
  String deleteVideoGallery(int id) => "/delete-video-gallery/$id";

  // Electronic Media
  final String electronicMedia = "/electronic-media";
  final String storeElectronicMedia = "/store-electronic-media";
  String findElectronicMedia(int id) => "/find-electronic-media/$id";
  String updateElectronicMedia(int id) => "/update-electronic-media/$id";
  String deleteElectronicMedia(int id) => "/delete-electronic-media/$id";

  // Legacy Public Users
  final String users = "/users";

  // ─────────────────────────────────────────────────────────────
  // 6. Admin Endpoints
  // ─────────────────────────────────────────────────────────────
  final String dashboard = "/dashboard";
  final String permissions = "/permissions";

  // Admin Citizen Requests
  final String adminCitizenRequests = "/admin/citizen-requests";
  String adminCitizenRequestById(int id) => "/admin/citizen-requests/$id";
  String adminCitizenRequestStatus(int id) => "/admin/citizen-requests/$id/status";

  // Admin Unions
  final String adminUnions = "/admin/unions";
  String adminUnionById(int id) => "/admin/unions/$id";

  // Admin Users
  final String adminUsers = "/admin/users";
  String adminUserById(int id) => "/admin/users/$id";

  // ─────────────────────────────────────────────────────────────
  // Legacy / fallback endpoints
  // ─────────────────────────────────────────────────────────────
  final String userProfile = "/me";
  final String privacyPolicy = "/about";
  final String termsAndConditions = "/about";
  final String faq = "/faq";
  final String notification = "/notification";
  final String user = "/me";
}
