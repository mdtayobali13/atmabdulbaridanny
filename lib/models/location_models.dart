class DivisionModel {
  final int id;
  final String name;
  final String? bnName;

  const DivisionModel({
    required this.id,
    required this.name,
    this.bnName,
  });

  String localizedName(bool isBangla) => (isBangla && bnName != null && bnName!.isNotEmpty) ? bnName! : name;

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      bnName: json['bn_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bn_name': bnName,
      };
}

class DistrictModel {
  final int id;
  final int? divisionId;
  final String name;
  final String? bnName;

  const DistrictModel({
    required this.id,
    this.divisionId,
    required this.name,
    this.bnName,
  });

  String localizedName(bool isBangla) => (isBangla && bnName != null && bnName!.isNotEmpty) ? bnName! : name;

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      divisionId: json['division_id'] is int
          ? json['division_id'] as int
          : int.tryParse(json['division_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      bnName: json['bn_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'division_id': divisionId,
        'name': name,
        'bn_name': bnName,
      };
}

class UpazilaModel {
  final int id;
  final int? districtId;
  final String name;
  final String? bnName;

  const UpazilaModel({
    required this.id,
    this.districtId,
    required this.name,
    this.bnName,
  });

  String localizedName(bool isBangla) => (isBangla && bnName != null && bnName!.isNotEmpty) ? bnName! : name;

  factory UpazilaModel.fromJson(Map<String, dynamic> json) {
    return UpazilaModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      districtId: json['district_id'] is int
          ? json['district_id'] as int
          : int.tryParse(json['district_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      bnName: json['bn_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'district_id': districtId,
        'name': name,
        'bn_name': bnName,
      };
}

class UnionModel {
  final int id;
  final int? upazillaId;
  final String name;
  final String? bnName;

  const UnionModel({
    required this.id,
    this.upazillaId,
    required this.name,
    this.bnName,
  });

  String localizedName(bool isBangla) => (isBangla && bnName != null && bnName!.isNotEmpty) ? bnName! : name;

  factory UnionModel.fromJson(Map<String, dynamic> json) {
    return UnionModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      upazillaId: json['upazilla_id'] is int
          ? json['upazilla_id'] as int
          : int.tryParse(json['upazilla_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      bnName: json['bn_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'upazilla_id': upazillaId,
        'name': name,
        'bn_name': bnName,
      };
}
