import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/entities/userRoles.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/data/entities/auth_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthService {
  static final String _hostUrl = GlobalConfig.baseUrl;
  static final Dio _httpClientConn = httpClient;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  static Future<bool> isConnected() =>
      InternetConnectionChecker().hasConnection;

  static Future<Either<void, ErrorMessage>> registerNewUser(
      AuthDTO user) async {
    try {
      await _httpClientConn.post("$_hostUrl/api/v1/admin/user/register",
          data: user.toJson());
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while registrering new user',
        fatal: true,
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return left(null);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("TOKEN");
    prefs.remove("USER");
  }

  static Future<LoginData?> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("USER");
    String? authToken = prefs.getString("TOKEN");
    if (user != null && authToken != null) {
      return LoginData(
        user: User.fromJson(
          jsonDecode(user),
        ),
        authToken: authToken,
      );
    }
    return null;
  }

  static Future<Either<LoginData, ErrorMessage>> logInUser(
      String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await _httpClientConn.post(
        "$_hostUrl/api/v1/admin/user/login",
        data: {
          'email': email,
          'password': password,
        },
      );
      String token = result.data["payload"]["token"];
      User user = User.fromJson(result.data["payload"]["user"]);

      prefs.setString('TOKEN', result.data["payload"]["token"]);
      prefs.setString('USER', result.data["payload"]["token"]);

      return Left(
        LoginData(
          user: user,
          authToken: token,
        ),
      );
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'User login error',
        fatal: true,
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<User, ErrorMessage>> updateProfile(User data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String authToken = GlobalConfig.instance.appKey;
      var profile = await _httpClientConn.put(
          "$_hostUrl/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
          data: json.encode({
            'name': data.name,
            "phone": data.phone,
          }));

      User user = User.fromJson(profile.data["user"]);
      prefs.setString("user", userToJson(user));
      return Left(user);
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while updating user profile',
        fatal: true,
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<UserRole, ErrorMessage>> getUserRoles(
      String userId) async {
    try {
      String authToken = GlobalConfig.instance.appKey;
      var result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/role/$userId",
        options:
            Options(headers: {'Authorization': authToken}, sendTimeout: 10000),
      );
      Iterable userRoles = result.data["userRole"]["role"];
      return Left(UserRole(List<String>.from(userRoles.map((r) => r["name"]))));
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while acquiring a user\'s roles',
        fatal: true,
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<User, ErrorMessage>?> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final authToken = GlobalConfig.instance.authToken;
      String? user = prefs.getString("user");

      if (user == null) {
        var profile = await _httpClientConn.get(
          "$_hostUrl/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
        );
        User user = User.fromJson(profile.data["user"]);
        prefs.setString("user", userToJson(user));
        return Left(user);
      }
      return Left(User.fromJson(json.decode(user)));
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while acquiring a user\'s profile',
        fatal: true,
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<User, ErrorMessage>?> getStudentProfile(
      String userId) async {
    try {
      final authToken = GlobalConfig.instance.authToken;
      var profile = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/studentprofile/$userId",
        options:
            Options(headers: {'Authorization': authToken}, sendTimeout: 10000),
      );
      User user = User.fromJson(profile.data["user"]);
      return Left(user);
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while acquiring a student\'s profile details',
        fatal: true,
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
