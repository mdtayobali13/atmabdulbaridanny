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
  final int aboutMe;
  final int slider;
  final int news;
  final int blog;
  final int developmentWork;
  final int appointments;
  final int complaints;
  final int websiteSetting;
  final int footerLink;
  final int users;
  final int galleryCategory;

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
    this.aboutMe = 0,
    this.slider = 0,
    this.news = 0,
    this.blog = 0,
    this.developmentWork = 0,
    this.appointments = 0,
    this.complaints = 0,
    this.websiteSetting = 0,
    this.footerLink = 0,
    this.users = 0,
    this.galleryCategory = 0,
  });

  int get aboutUsCount => aboutUs.isNotEmpty ? aboutUs.length : (aboutUsCountDirect > 0 ? aboutUsCountDirect : 0);
  int get resourceCount => resource.isNotEmpty ? resource.length : (resourceCountDirect > 0 ? resourceCountDirect : 0);
  int get servicesCount => services.isNotEmpty ? services.length : (servicesCountDirect > 0 ? servicesCountDirect : 0);

  int getSubCount(List<dynamic> list, String name, String key) {
    for (final item in list) {
      if (item is Map && (item['title_en']?.toString().toLowerCase().contains(name.toLowerCase()) == true)) {
        if (item[key] is List) {
          return (item[key] as List).length;
        }
      }
    }
    return 0;
  }

  int get achievementCount => getSubCount(aboutUs, 'Achiev', 'about_us_content');
  int get journeyCount => getSubCount(aboutUs, 'Journey', 'about_us_content');
  int get precedentsCount => getSubCount(resource, 'Precedent', 'resource_content');
  int get researchCount => getSubCount(resource, 'Research', 'resource_content');
  int get storiesCount => getSubCount(resource, 'Stor', 'resource_content');
  int get proBonoCount => getSubCount(services, 'Pro Bono', 'services');
  int get companyCount => getSubCount(services, 'Company', 'services');
  int get familyLawyerCount => getSubCount(services, 'Family', 'services');
  int get civilCount => getSubCount(services, 'Civil', 'services');
  int get constitutionalLawCount => getSubCount(services, 'Constitutional', 'services');
  int get criminalCount => getSubCount(services, 'Criminal', 'services');

  // Hidden direct count fields if provided as integer in json
  int get aboutUsCountDirect => _aboutUsCountDirect;
  int get resourceCountDirect => _resourceCountDirect;
  int get servicesCountDirect => _servicesCountDirect;

  static int _aboutUsCountDirect = 0;
  static int _resourceCountDirect = 0;
  static int _servicesCountDirect = 0;

  static int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is List) return val.length;
    if (val is Map) return val.containsKey('count') ? _parseInt(val['count']) : 1;
    return int.tryParse(val.toString()) ?? 0;
  }

  factory AdminDashboardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AdminDashboardModel();

    _aboutUsCountDirect = json['about_us_count'] is int
        ? json['about_us_count'] as int
        : (json['about_us'] is int ? json['about_us'] as int : 0);

    _resourceCountDirect = json['resource_count'] is int
        ? json['resource_count'] as int
        : (json['resource'] is int ? json['resource'] as int : 0);

    _servicesCountDirect = json['services_count'] is int
        ? json['services_count'] as int
        : (json['services'] is int ? json['services'] as int : 0);

    return AdminDashboardModel(
      photoGallery: _parseInt(json['photo_gallery'] ?? json['photoGallery']),
      videoGallery: _parseInt(json['video_gallery'] ?? json['videoGallery']),
      biography: _parseInt(json['biography']),
      lifeStruggle: _parseInt(json['life_struggle'] ?? json['lifeStruggle']),
      printMedia: _parseInt(json['printMedia'] ?? json['print_media']),
      electronicMedia: _parseInt(json['electronicMedia'] ?? json['electronic_media']),
      aboutUs: json['about_us'] is List ? json['about_us'] as List : const [],
      resource: json['resource'] is List ? json['resource'] as List : const [],
      services: json['services'] is List ? json['services'] as List : const [],
      aboutMe: _parseInt(json['about_me'] ?? json['aboutMe']),
      slider: _parseInt(json['slider'] ?? json['sliders']),
      news: _parseInt(json['news']),
      blog: _parseInt(json['blog'] ?? json['blogs']),
      developmentWork: _parseInt(json['development_work'] ?? json['development_work_content'] ?? json['developmentWork']),
      appointments: _parseInt(json['appointments'] ?? json['appointment']),
      complaints: _parseInt(json['complaints'] ?? json['citizen_requests'] ?? json['citizenRequests']),
      websiteSetting: _parseInt(json['website_setting'] ?? json['websiteSetting'] ?? json['website_settings']),
      footerLink: _parseInt(json['footer_link'] ?? json['footerLink'] ?? json['footer_links']),
      users: _parseInt(json['users'] ?? json['admin_users']),
      galleryCategory: _parseInt(json['gallery_category'] ?? json['gallery_categories']),
    );
  }
}

class ContactMessageModel {
  final int? id;
  final String? name;
  final String? email;
  final String? number;
  final String? subject;
  final String? message;
  final String? type;
  final String? createdAt;

  const ContactMessageModel({
    this.id,
    this.name,
    this.email,
    this.number,
    this.subject,
    this.message,
    this.type,
    this.createdAt,
  });

  factory ContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactMessageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      number: json['number']?.toString() ?? json['phone']?.toString() ?? json['mobile']?.toString(),
      subject: json['subject']?.toString(),
      message: json['message']?.toString(),
      type: json['type']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'subject': subject,
      'message': message,
      'type': type,
      'created_at': createdAt,
    };
  }
}

