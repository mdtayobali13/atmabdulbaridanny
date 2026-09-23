import 'package:atmabdulbaridanny/models/content_models.dart';
import 'package:atmabdulbaridanny/models/gallery_and_media_models.dart';
import 'package:atmabdulbaridanny/models/service_and_development_models.dart';

class HomeDataModel {
  final List<NewsModel> news;
  final List<LifeStruggleModel> life;
  final List<SliderModel> slider;
  final List<BlogModel> blog;
  final List<GalleryCategoryModel> galleryCategory;
  final List<VideoGalleryModel> videoGallery;
  final List<ResourceContentModel> resourceContent;
  final List<AboutMeModel> aboutMe;

  const HomeDataModel({
    this.news = const [],
    this.life = const [],
    this.slider = const [],
    this.blog = const [],
    this.galleryCategory = const [],
    this.videoGallery = const [],
    this.resourceContent = const [],
    this.aboutMe = const [],
  });

  factory HomeDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HomeDataModel();

    List<T> parseList<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    }

    return HomeDataModel(
      news: parseList(json['News'], (m) => NewsModel.fromJson(m)),
      life: parseList(json['Life'], (m) => LifeStruggleModel.fromJson(m)),
      slider: parseList(json['Slider'], (m) => SliderModel.fromJson(m)),
      blog: parseList(json['Blog'], (m) => BlogModel.fromJson(m)),
      galleryCategory: parseList(json['GalleryCategory'], (m) => GalleryCategoryModel.fromJson(m)),
      videoGallery: parseList(json['VideoGallery'], (m) => VideoGalleryModel.fromJson(m)),
      resourceContent: parseList(json['ResourceContent'], (m) => ResourceContentModel.fromJson(m)),
      aboutMe: parseList(json['AboutMe'], (m) => AboutMeModel.fromJson(m)),
    );
  }
}
