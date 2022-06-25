import 'package:dio/dio.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/entities/user_roles.dart';
import 'package:rada_egerton/data/services/auth_service.dart';

class GlobalConfig {
  String pusherApiKey = "8da328d2097b06731d0a";
  static String baseUrl = "https://radaegerton.ddns.net";
  String appKey = "";
  String authToken = "";
  User user = User.empty();
  UserRole? _userRoles;
  
  //placeholder avatar images
  static String userAvi =
      "https://img.icons8.com/ios-glyphs/90/000000/user--v1.png";
  static String usersApi =
      "https://img.icons8.com/ios-glyphs/90/000000/group.png";

  Future<UserRole> get userRoles async {
    if (_userRoles != null) {
      return _userRoles!;
    }
    final res = await AuthService.getUserRoles(
      user.id.toString(),
    );
    res.fold(
      (roles) => _userRoles = roles,
      (error) => throw (error),
    );
    return _userRoles!;
  }

  void inialize({
    String? authToken,
    User? user,
  }) {
    this.user = user ?? this.user;
    this.authToken = authToken ?? this.authToken;
  }

  GlobalConfig._();
  static GlobalConfig instance = GlobalConfig._();
}

Dio httpClient = Dio(
  BaseOptions(
    connectTimeout: 10000,
    receiveTimeout: 10000,
  ),
);

String imageUrl(String path) {
  if (path.startsWith("/")) {
    return "${GlobalConfig.baseUrl}/api/v1/uploads$path";
  }
  return "${GlobalConfig.baseUrl}/api/v1/uploads/$path";
}

String url({required String url, Map<String, dynamic>? queryParams}) {
  if (url.startsWith("/")) {
    url = url.substring(1);
  }
  String absoluteUrl = "${GlobalConfig.baseUrl}/$url";
  if (queryParams != null) {
    List<String> query = [];
    for (String key in queryParams.keys) {
      query.add("$key=${queryParams[key]}");
    }
    absoluteUrl = "$absoluteUrl?${query.join("&")}";
  }
  return absoluteUrl;
}
