class CitizenRequestModel {
  final int? id;
  final String? requestType; // 'complaint' or 'appointment'
  final String? status; // 'pending', 'processing', 'approved', 'rejected', 'completed'
  final String? trackingNo;
  final String? name;
  final String? mobile;
  final String? email;
  final String? type; // 'local' or 'nrb'
  final int? divisionId;
  final int? districtId;
  final int? upazilaId;
  final int? unionId;
  final String? divisionName;
  final String? districtName;
  final String? upazilaName;
  final String? unionName;
  final String? wardNo;
  final String? village;
  final String? subject;
  final String? message;
  final String? appointmentDate;
  final String? createdAt;
  final String? updatedAt;

  const CitizenRequestModel({
    this.id,
    this.requestType,
    this.status,
    this.trackingNo,
    this.name,
    this.mobile,
    this.email,
    this.type,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.divisionName,
    this.districtName,
    this.upazilaName,
    this.unionName,
    this.wardNo,
    this.village,
    this.subject,
    this.message,
    this.appointmentDate,
    this.createdAt,
    this.updatedAt,
  });

  factory CitizenRequestModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CitizenRequestModel();
    return CitizenRequestModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      requestType: json['request_type']?.toString(),
      status: json['status']?.toString(),
      trackingNo: json['tracking_no']?.toString(),
      name: json['name']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      type: json['type']?.toString(),
      divisionId: json['division_id'] is int
          ? json['division_id'] as int
          : int.tryParse(json['division_id']?.toString() ?? ''),
      districtId: json['district_id'] is int
          ? json['district_id'] as int
          : int.tryParse(json['district_id']?.toString() ?? ''),
      upazilaId: json['upazila_id'] is int
          ? json['upazila_id'] as int
          : int.tryParse(json['upazila_id']?.toString() ?? ''),
      unionId: json['union_id'] is int
          ? json['union_id'] as int
          : int.tryParse(json['union_id']?.toString() ?? ''),
      divisionName: json['division_name']?.toString(),
      districtName: json['district_name']?.toString(),
      upazilaName: json['upazila_name']?.toString(),
      unionName: json['union_name']?.toString(),
      wardNo: json['ward_no']?.toString(),
      village: json['village']?.toString(),
      subject: json['subject']?.toString(),
      message: json['message']?.toString(),
      appointmentDate: json['appointment_date']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class CitizenRequestFilter {
  final String? requestType; // 'complaint' or 'appointment'
  final String? status; // 'pending', 'processing', 'approved', 'rejected', 'completed'
  final int? divisionId;
  final int? districtId;
  final String? mobile;
  final String? trackingNo;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final int? perPage;

  const CitizenRequestFilter({
    this.requestType,
    this.status,
    this.divisionId,
    this.districtId,
    this.mobile,
    this.trackingNo,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.perPage,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (requestType != null && requestType!.isNotEmpty) params['request_type'] = requestType;
    if (status != null && status!.isNotEmpty) params['status'] = status;
    if (divisionId != null) params['division_id'] = divisionId;
    if (districtId != null) params['district_id'] = districtId;
    if (mobile != null && mobile!.isNotEmpty) params['mobile'] = mobile;
    if (trackingNo != null && trackingNo!.isNotEmpty) params['tracking_no'] = trackingNo;
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (sortBy != null && sortBy!.isNotEmpty) params['sort_by'] = sortBy;
    if (sortOrder != null && sortOrder!.isNotEmpty) params['sort_order'] = sortOrder;
    if (perPage != null) params['per_page'] = perPage;
    return params;
  }
}
