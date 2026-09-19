import 'package:barristerkayserkamal/models/admin_dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/models/auth_user_model.dart';
import 'package:barristerkayserkamal/models/citizen_request_models.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/services/repository/admin_repository.dart';
import 'package:barristerkayserkamal/services/repository/citizen_request_repository.dart';

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
