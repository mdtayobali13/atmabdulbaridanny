class AdminDashboardModel {
  final int photoGallery;
  final int videoGallery;
  final int biography;
  final int lifeStruggle;
  final int printMedia;
  final int electronicMedia;
  final List<dynamic> aboutUs;
  final List<dynamic> resource;
  final List<dynamic> services;

  const AdminDashboardModel({
    this.photoGallery = 0,
    this.videoGallery = 0,
    this.biography = 0,
    this.lifeStruggle = 0,
    this.printMedia = 0,
    this.electronicMedia = 0,
    this.aboutUs = const [],
    this.resource = const [],
    this.services = const [],
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AdminDashboardModel();
    return AdminDashboardModel(
      photoGallery: json['photo_gallery'] is int ? json['photo_gallery'] as int : int.tryParse(json['photo_gallery']?.toString() ?? '') ?? 0,
      videoGallery: json['video_gallery'] is int ? json['video_gallery'] as int : int.tryParse(json['video_gallery']?.toString() ?? '') ?? 0,
      biography: json['biography'] is int ? json['biography'] as int : int.tryParse(json['biography']?.toString() ?? '') ?? 0,
      lifeStruggle: json['life_struggle'] is int ? json['life_struggle'] as int : int.tryParse(json['life_struggle']?.toString() ?? '') ?? 0,
      printMedia: json['printMedia'] is int ? json['printMedia'] as int : int.tryParse(json['printMedia']?.toString() ?? '') ?? 0,
      electronicMedia: json['electronicMedia'] is int ? json['electronicMedia'] as int : int.tryParse(json['electronicMedia']?.toString() ?? '') ?? 0,
      aboutUs: json['about_us'] is List ? json['about_us'] as List : const [],
      resource: json['resource'] is List ? json['resource'] as List : const [],
      services: json['services'] is List ? json['services'] as List : const [],
    );
  }
}
