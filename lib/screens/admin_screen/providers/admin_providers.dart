import 'package:atmabdulbaridanny/models/admin_dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/models/auth_user_model.dart';
import 'package:atmabdulbaridanny/models/citizen_request_models.dart';
import 'package:atmabdulbaridanny/models/content_models.dart';
import 'package:atmabdulbaridanny/services/repository/admin_repository.dart';
import 'package:atmabdulbaridanny/services/repository/citizen_request_repository.dart';

final adminCitizenRequestsProvider = FutureProvider<List<CitizenRequestModel>>((ref) async {
  return CitizenRequestRepository.instance.getAdminCitizenRequests();
});

final adminUsersListProvider = FutureProvider<List<AuthUserModel>>((ref) async {
  return AdminRepository.instance.getAdminUsers();
});

final adminContactListProvider = FutureProvider<List<ContactMessageModel>>((ref) async {
  return AdminRepository.instance.getContactList();
});

final adminAboutMeListProvider = FutureProvider<List<AboutMeModel>>((ref) async {
  return AdminRepository.instance.getAboutMeList();
});
