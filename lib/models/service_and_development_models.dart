import 'package:atmabdulbaridanny/constant/app_api_url.dart';

class ServiceModel {
  final int? id;
  final int? serviceCategoryId;
  final String? snEn;
  final String? snBn;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;

  const ServiceModel({
    this.id,
    this.serviceCategoryId,
    this.snEn,
    this.snBn,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
  });

  factory ServiceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ServiceModel();
    return ServiceModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      serviceCategoryId: json['service_category_id'] is int
          ? json['service_category_id'] as int
          : int.tryParse(json['service_category_id']?.toString() ?? ''),
      snEn: json['sn_en']?.toString(),
      snBn: json['sn_bn']?.toString(),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
    );
  }
}

class ServiceCategoryModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final int? index;
  final List<ServiceModel> services;

  const ServiceCategoryModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.index,
    this.services = const [],
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ServiceCategoryModel();
    List<ServiceModel> list = [];
    if (json['services'] is List) {
      list = (json['services'] as List)
          .whereType<Map>()
          .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return ServiceCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      index: json['index'] is int ? json['index'] as int : int.tryParse(json['index']?.toString() ?? ''),
      services: list,
    );
  }
}

class AboutUsContentModel {
  final int? id;
  final int? aboutUsCategoryId;
  final String? dateEn;
  final String? dateBn;
  final String? yearEn;
  final String? yearBn;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? cardColor;
  final String? bntColor;

  const AboutUsContentModel({
    this.id,
    this.aboutUsCategoryId,
    this.dateEn,
    this.dateBn,
    this.yearEn,
    this.yearBn,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.cardColor,
    this.bntColor,
  });

  factory AboutUsContentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AboutUsContentModel();
    return AboutUsContentModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      aboutUsCategoryId: json['about_us_category_id'] is int
          ? json['about_us_category_id'] as int
          : int.tryParse(json['about_us_category_id']?.toString() ?? ''),
      dateEn: json['date_en']?.toString(),
      dateBn: json['date_bn']?.toString(),
      yearEn: json['year_en']?.toString(),
      yearBn: json['year_bn']?.toString(),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      cardColor: json['card_color']?.toString(),
      bntColor: json['bnt_color']?.toString(),
    );
  }
}

class AboutUsCategoryModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final int? index;
  final List<AboutUsContentModel> contents;

  const AboutUsCategoryModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.index,
    this.contents = const [],
  });

  factory AboutUsCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AboutUsCategoryModel();
    List<AboutUsContentModel> list = [];
    if (json['contents'] is List) {
      list = (json['contents'] as List)
          .whereType<Map>()
          .map((e) => AboutUsContentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return AboutUsCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      index: json['index'] is int ? json['index'] as int : int.tryParse(json['index']?.toString() ?? ''),
      contents: list,
    );
  }
}

class DevelopmentWorkContentModel {
  final int? id;
  final int? developmentWorkCategoryId;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? image;

  const DevelopmentWorkContentModel({
    this.id,
    this.developmentWorkCategoryId,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.image,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(image);

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  String localizedContent(bool isBn) {
    if (isBn && contentBn != null && contentBn!.isNotEmpty) return contentBn!;
    return contentEn ?? contentBn ?? '';
  }

  factory DevelopmentWorkContentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const DevelopmentWorkContentModel();
    return DevelopmentWorkContentModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      developmentWorkCategoryId: json['development_work_category_id'] is int
          ? json['development_work_category_id'] as int
          : int.tryParse(json['development_work_category_id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      image: json['image']?.toString(),
    );
  }
}

class DevelopmentWorkCategoryModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final int? index;
  final List<DevelopmentWorkContentModel> contents;

  const DevelopmentWorkCategoryModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.index,
    this.contents = const [],
  });

  factory DevelopmentWorkCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const DevelopmentWorkCategoryModel();
    List<DevelopmentWorkContentModel> list = [];
    if (json['contents'] is List) {
      list = (json['contents'] as List)
          .whereType<Map>()
          .map((e) => DevelopmentWorkContentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return DevelopmentWorkCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      index: json['index'] is int ? json['index'] as int : int.tryParse(json['index']?.toString() ?? ''),
      contents: list,
    );
  }
}

class ResourceContentModel {
  final int? id;
  final int? resourceCategoryId;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? file;

  const ResourceContentModel({
    this.id,
    this.resourceCategoryId,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.file,
  });

  String get fullFileUrl => AppApiUrl.imageUrl(file);

  factory ResourceContentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ResourceContentModel();
    return ResourceContentModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      resourceCategoryId: json['resource_category_id'] is int
          ? json['resource_category_id'] as int
          : int.tryParse(json['resource_category_id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      file: json['file']?.toString(),
    );
  }
}

class ResourceCategoryModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final int? index;
  final List<ResourceContentModel> contents;

  const ResourceCategoryModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.index,
    this.contents = const [],
  });

  factory ResourceCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ResourceCategoryModel();
    List<ResourceContentModel> list = [];
    if (json['contents'] is List) {
      list = (json['contents'] as List)
          .whereType<Map>()
          .map((e) => ResourceContentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return ResourceCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      index: json['index'] is int ? json['index'] as int : int.tryParse(json['index']?.toString() ?? ''),
      contents: list,
    );
  }
}
