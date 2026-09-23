import 'package:atmabdulbaridanny/constant/app_api_url.dart';

class GalleryCategoryModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const GalleryCategoryModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBangla) =>
      (isBangla ? titleBn : titleEn) ?? titleBn ?? titleEn ?? '';

  factory GalleryCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const GalleryCategoryModel();
    return GalleryCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      file: json['file']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_bn': titleBn,
      'file': file,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PhotoGalleryModel {
  final int? id;
  final int? galleryCategoryId;
  final String? titleEn;
  final String? titleBn;
  final String? file; // cover image
  final List<String> files; // array of photos
  final String? createdAt;
  final String? updatedAt;

  const PhotoGalleryModel({
    this.id,
    this.galleryCategoryId,
    this.titleEn,
    this.titleBn,
    this.file,
    this.files = const [],
    this.createdAt,
    this.updatedAt,
  });

  String get fullCoverUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  List<String> get allImageUrls {
    final list = <String>[];
    if (file != null && file!.isNotEmpty) {
      list.add(AppApiUrl.imageUrl(file));
    }
    for (final f in files) {
      list.add(AppApiUrl.imageUrl(f));
    }
    return list;
  }

  factory PhotoGalleryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PhotoGalleryModel();

    List<String> parsedFiles = [];
    if (json['files'] is List) {
      parsedFiles = (json['files'] as List).map((e) => e.toString()).toList();
    }

    return PhotoGalleryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      galleryCategoryId: json['gallery_category_id'] is int
          ? json['gallery_category_id'] as int
          : int.tryParse(json['gallery_category_id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      file: json['file']?.toString(),
      files: parsedFiles,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class VideoGalleryModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? link;
  final String? file;
  final String? contentEn;
  final String? contentBn;
  final String? createdAt;
  final String? updatedAt;

  const VideoGalleryModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.link,
    this.file,
    this.contentEn,
    this.contentBn,
    this.createdAt,
    this.updatedAt,
  });

  String get fullThumbnailUrl => AppApiUrl.imageUrl(file);
  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  String localizedContent(bool isBn) {
    if (isBn && contentBn != null && contentBn!.isNotEmpty) return contentBn!;
    return contentEn ?? contentBn ?? '';
  }

  String? get youtubeVideoId {
    if (link == null || link!.isEmpty) return null;
    final regExp = RegExp(
      r'^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(link!);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  factory VideoGalleryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const VideoGalleryModel();
    return VideoGalleryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      link: json['link']?.toString(),
      file: json['file']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class ElectronicMediaModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? link;
  final String? file;
  final String? contentEn;
  final String? contentBn;
  final String? createdAt;
  final String? updatedAt;

  const ElectronicMediaModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.link,
    this.file,
    this.contentEn,
    this.contentBn,
    this.createdAt,
    this.updatedAt,
  });

  String get fullThumbnailUrl => AppApiUrl.imageUrl(file);
  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  String localizedContent(bool isBn) {
    if (isBn && contentBn != null && contentBn!.isNotEmpty) return contentBn!;
    return contentEn ?? contentBn ?? '';
  }

  String? get youtubeVideoId {
    if (link == null || link!.isEmpty) return null;
    final regExp = RegExp(
      r'^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(link!);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  factory ElectronicMediaModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ElectronicMediaModel();
    return ElectronicMediaModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      link: json['link']?.toString(),
      file: json['file']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
