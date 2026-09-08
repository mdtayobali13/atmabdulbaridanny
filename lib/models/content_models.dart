import 'package:flutter_riverpod_template/constant/app_api_url.dart';

class NewsModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const NewsModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBangla) =>
      (isBangla ? titleBn : titleEn) ?? titleBn ?? titleEn ?? '';

  String localizedContent(bool isBangla) =>
      (isBangla ? contentBn : contentEn) ?? contentBn ?? contentEn ?? '';

  factory NewsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NewsModel();
    return NewsModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
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
      'content_en': contentEn,
      'content_bn': contentBn,
      'file': file,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class BlogModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const BlogModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBangla) =>
      (isBangla ? titleBn : titleEn) ?? titleBn ?? titleEn ?? '';

  String localizedContent(bool isBangla) =>
      (isBangla ? contentBn : contentEn) ?? contentBn ?? contentEn ?? '';

  factory BlogModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BlogModel();
    return BlogModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
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
      'content_en': contentEn,
      'content_bn': contentBn,
      'file': file,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SliderModel {
  final int? id;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const SliderModel({
    this.id,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  factory SliderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SliderModel();
    return SliderModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      file: json['file']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AboutModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? file;
  final String? fb;
  final String? yt;
  final String? twi;
  final String? createdAt;
  final String? updatedAt;

  const AboutModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.file,
    this.fb,
    this.yt,
    this.twi,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  factory AboutModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AboutModel();
    return AboutModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      file: json['file']?.toString(),
      fb: json['fb']?.toString(),
      yt: json['yt']?.toString(),
      twi: json['twi']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class BiographyModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const BiographyModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  String localizedContent(bool isBn) {
    if (isBn && contentBn != null && contentBn!.isNotEmpty) return contentBn!;
    return contentEn ?? contentBn ?? '';
  }

  factory BiographyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BiographyModel();
    return BiographyModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      file: json['file']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class LifeStruggleModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const LifeStruggleModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  String localizedContent(bool isBn) {
    if (isBn && contentBn != null && contentBn!.isNotEmpty) return contentBn!;
    return contentEn ?? contentBn ?? '';
  }

  factory LifeStruggleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LifeStruggleModel();
    return LifeStruggleModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      file: json['file']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class AboutMeModel {
  final int? id;
  final String? contentEn;
  final String? contentBn;
  final String? file;
  final String? createdAt;
  final String? updatedAt;

  const AboutMeModel({
    this.id,
    this.contentEn,
    this.contentBn,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  String get fullImageUrl => AppApiUrl.imageUrl(file);

  String localizedContent(bool isBn) {
    if (isBn && contentBn != null && contentBn!.isNotEmpty) return contentBn!;
    return contentEn ?? contentBn ?? '';
  }

  factory AboutMeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AboutMeModel();
    return AboutMeModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      file: json['file']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class WebsiteSettingModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? contentEn;
  final String? contentBn;
  final String? messageEn;
  final String? messageBn;
  final String? googleMap;
  final String? fbPage;
  final String? fb;
  final String? yt;
  final String? twi;
  final String? mobile;
  final String? email;
  final String? address;
  final String? file;
  final String? banner;
  final String? adminLogo;

  const WebsiteSettingModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.contentEn,
    this.contentBn,
    this.messageEn,
    this.messageBn,
    this.googleMap,
    this.fbPage,
    this.fb,
    this.yt,
    this.twi,
    this.mobile,
    this.email,
    this.address,
    this.file,
    this.banner,
    this.adminLogo,
  });

  String get fullLogoUrl => AppApiUrl.imageUrl(file);
  String get fullFileUrl => AppApiUrl.imageUrl(file);
  String get fullBannerUrl => AppApiUrl.imageUrl(banner);
  String get fullAdminLogoUrl => AppApiUrl.imageUrl(adminLogo);

  factory WebsiteSettingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const WebsiteSettingModel();
    return WebsiteSettingModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentBn: json['content_bn']?.toString(),
      messageEn: json['message_en']?.toString(),
      messageBn: json['message_bn']?.toString(),
      googleMap: json['google_map']?.toString(),
      fbPage: json['fb_page']?.toString(),
      fb: json['fb']?.toString(),
      yt: json['yt']?.toString(),
      twi: json['twi']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      file: json['file']?.toString(),
      banner: json['banner']?.toString(),
      adminLogo: json['admin_logo']?.toString(),
    );
  }
}

class FooterLinkModel {
  final int? id;
  final String? titleEn;
  final String? titleBn;
  final String? link;

  const FooterLinkModel({
    this.id,
    this.titleEn,
    this.titleBn,
    this.link,
  });

  String localizedTitle(bool isBn) {
    if (isBn && titleBn != null && titleBn!.isNotEmpty) return titleBn!;
    return titleEn ?? titleBn ?? '';
  }

  factory FooterLinkModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FooterLinkModel();
    return FooterLinkModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      titleEn: json['title_en']?.toString(),
      titleBn: json['title_bn']?.toString(),
      link: json['link']?.toString(),
    );
  }
}

class AppointmentModel {
  final int? id;
  final String? name;
  final String? subject;
  final String? message;
  final String? number;
  final String? district;
  final String? date;
  final String? type; // 'contact' or 'appointment'
  final String? createdAt;

  const AppointmentModel({
    this.id,
    this.name,
    this.subject,
    this.message,
    this.number,
    this.district,
    this.date,
    this.type,
    this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AppointmentModel();
    return AppointmentModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      subject: json['subject']?.toString(),
      message: json['message']?.toString(),
      number: json['number']?.toString(),
      district: json['district']?.toString(),
      date: json['date']?.toString(),
      type: json['type']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
