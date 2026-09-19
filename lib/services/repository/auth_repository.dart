import 'package:dio/dio.dart';
import 'package:barristerkayserkamal/constant/app_api_url.dart';
import 'package:barristerkayserkamal/models/auth_user_model.dart';
import 'package:barristerkayserkamal/services/api/api_services.dart';
import 'package:barristerkayserkamal/services/storage/storage_services.dart';
import 'package:barristerkayserkamal/utils/app_log.dart';

class AuthRepository {
  AuthRepository._privateConstructor();
  static final AuthRepository _instance = AuthRepository._privateConstructor();
  static AuthRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;
  final StorageServices _storage = StorageServices.instance;

  // ─────────────────────────────────────────────────────────────
  // Standard tymon/jwt-auth Methods
  // ─────────────────────────────────────────────────────────────

  /// Log in and receive JWT token and user info
  Future<bool> login({
    required String email,
    required String password,
    String fcmToken = "",
    String deviceId = "",
  }) async {
    try {
      final bodyData = {
        "email": email.trim().toLowerCase(),
        "password": password.trim(),
      };

      final response = await _apiServices.postServices(url: _api.login, body: bodyData);

      if (response != null && response is Map) {
        // tymon/jwt-auth format: {"token": "...", "user": {...}}
        final token = response['token'] ?? response['accessToken'];
        if (token != null && token.toString().isNotEmpty) {
          await _storage.setToken(token.toString());
        }

        if (response['user'] != null && response['user'] is Map) {
          final userMap = Map<String, dynamic>.from(response['user'] as Map);
          await _storage.setUserData(userMap);

          if (userMap['permissions'] is List) {
            final perms = (userMap['permissions'] as List).map((e) => e.toString()).toList();
            await _storage.setPermissions(perms);
          }
          if (userMap['role'] != null) {
            await _storage.setAppRoll(userMap['role'].toString());
          }
        }

        // Backward compatibility if backend wraps in response["data"]
        if (response['data'] != null && response['data'] is Map) {
          final data = response['data'] as Map;
          if (data['accessToken'] != null) {
            await _storage.setToken(data['accessToken'].toString());
          }
          if (data['role'] != null) {
            await _storage.setAppRoll(data['role'].toString());
          }
        }

        return true;
      }
    } catch (e) {
      errorLog("login repo error", e);
    }
    return false;
  }

  /// Register a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final bodyData = {
        "name": name.trim(),
        "email": email.trim().toLowerCase(),
        "password": password.trim(),
      };

      final response = await _apiServices.postServices(
        url: _api.register,
        body: bodyData,
        statusCodeStart: 200,
        statusCodeEnd: 201,
      );

      if (response != null && response is Map) {
        final token = response['token'];
        if (token != null && token.toString().isNotEmpty) {
          await _storage.setToken(token.toString());
        }
        if (response['user'] != null && response['user'] is Map) {
          await _storage.setUserData(Map<String, dynamic>.from(response['user'] as Map));
        }
        return true;
      }
    } catch (e) {
      errorLog("register repo error", e);
    }
    return false;
  }

  /// Invalidate token and log out
  Future<bool> logout() async {
    try {
      await _apiServices.postServices(url: _api.logout);
    } catch (e) {
      errorLog("logout repo error", e);
    } finally {
      await _storage.logout();
    }
    return true;
  }

  /// Get a new token via Bearer authentication
  Future<String?> refreshToken() async {
    try {
      final currentToken = await _storage.getToken();
      if (currentToken.isEmpty) return null;

      final response = await _apiServices.postServices(
        url: _api.refresh,
        options: Options(headers: {'Authorization': 'Bearer $currentToken'}),
      );

      if (response != null && response is Map && response['token'] != null) {
        final newToken = response['token'].toString();
        await _storage.setToken(newToken);
        return newToken;
      }
    } catch (e) {
      errorLog("refreshToken repo error", e);
    }
    return null;
  }

  /// Get currently authenticated user details
  Future<AuthUserModel?> getMe() async {
    try {
      final token = await _storage.getToken();
      if (token.isEmpty) {
        return null;
      }
      final response = await _apiServices.getServices(_api.me);
      if (response != null && response is Map) {
        final data = response['data'] is Map
            ? response['data'] as Map
            : response['user'] is Map
                ? response['user'] as Map
                : response;
        final user = AuthUserModel.fromJson(Map<String, dynamic>.from(data));
        if (user.id != null) {
          await _storage.setUserData(user.toJson());
          await _storage.setPermissions(user.permissions);
          return user;
        }
      }
      final localData = await _storage.getUserData();
      if (localData.isNotEmpty) {
        return AuthUserModel.fromJson(localData);
      }
    } catch (e) {
      errorLog("getMe repo error", e);
      final localData = await _storage.getUserData();
      if (localData.isNotEmpty) {
        return AuthUserModel.fromJson(localData);
      }
    }
    return null;
  }

  /// Send password reset email
  Future<bool> resetPassword({required String email}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.resetPassword,
        body: {"email": email.trim().toLowerCase()},
      );
      return response != null;
    } catch (e) {
      errorLog("resetPassword repo error", e);
      return false;
    }
  }

  /// Set new password using reset token
  Future<bool> updatePassword({required String token, required String newPassword}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.updatePassword(token),
        body: {"password": newPassword.trim()},
      );
      return response != null;
    } catch (e) {
      errorLog("updatePassword repo error", e);
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Legacy / Helper Methods (Preserved for compatibility)
  // ─────────────────────────────────────────────────────────────

  Future<bool> forgotPassword({required String email}) => resetPassword(email: email);

  Future<String> forgotVerifyEmail({required String email, required int otp}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.authVerifyEmail,
        body: {"email": email, "oneTimeCode": otp},
      );
      if (response != null && response is Map && response["data"] != null) {
        return response["data"].toString();
      }
    } catch (e) {
      errorLog("forgotVerifyEmail repo", e);
    }
    return "";
  }

  Future<bool> forgotResetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) => updatePassword(token: token, newPassword: newPassword);

  Future<bool> authOtpVerify({required String email, required int otp}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.authOtpVerify,
        body: {"email": email, "oneTimeCode": otp},
      );
      return response != null;
    } catch (e) {
      errorLog("authOtpVerify repo", e);
      return false;
    }
  }

  Future<bool> authResendOTP({required String email}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.userResendOtp,
        body: {"email": email},
      );
      return response != null;
    } catch (e) {
      errorLog("authResendOTP repo", e);
      return false;
    }
  }

  Future<bool> accountDelete({required String password}) async {
    try {
      final response = await _apiServices.deleteServices(
        url: _api.authDeleteAccount,
        body: {"password": password},
      );
      return response != null;
    } catch (e) {
      errorLog("accountDelete repo", e);
      return false;
    }
  }

  Future<bool> updateProfile({
    required int userId,
    required String name,
    required String email,
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
      };
      final response = await _apiServices.putServices(
        url: _api.adminUserById(userId),
        body: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response != null) {
        final currentData = await _storage.getUserData();
        currentData['name'] = name.trim();
        currentData['email'] = email.trim().toLowerCase();
        await _storage.setUserData(currentData);
        return true;
      }
    } catch (e) {
      errorLog("updateProfile repo error", e);
    }
    return false;
  }

  Future<bool> changePassword({
    String? currentPassword,
    required String newPassword,
    String? confirmPassword,
    int? userId,
    String? name,
    String? email,
  }) async {
    try {
      // 1. If userId is available, update via the validated admin/user PUT endpoint
      if (userId != null) {
        final body = <String, dynamic>{
          if (name != null && name.isNotEmpty) 'name': name.trim(),
          if (email != null && email.isNotEmpty) 'email': email.trim().toLowerCase(),
          'password': newPassword.trim(),
        };
        final response = await _apiServices.putServices(
          url: _api.adminUserById(userId),
          body: body,
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
        return response != null;
      }

      // 2. Fallback to legacy endpoint if userId not supplied
      final fallbackBody = <String, dynamic>{
        "newPassword": newPassword,
      };
      if (currentPassword != null) fallbackBody["currentPassword"] = currentPassword;
      if (confirmPassword != null) fallbackBody["confirmPassword"] = confirmPassword;

      final response = await _apiServices.postServices(
        url: _api.changePassword,
        body: fallbackBody,
      );
      return response != null;
    } catch (e) {
      errorLog("changePassword repo", e);
      return false;
    }
  }
}
