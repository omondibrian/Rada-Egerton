import 'package:dio/dio.dart';
import 'package:rada_egerton/entities/UserDTO.dart';

class GlobalConfig {
  String pusherApiKey = "8da328d2097b06731d0a";
  static String baseUrl = "http://192.168.90.100";
  String appKey = "";
  String authToken = "";
  User? _user;

  set setUser(User user) {
    user = user;
  }

  User? get user =>_user;

  static String imageUrl(String path) {
    if (path.startsWith("/")) {
      return "$baseUrl/api/v1/uploads$path";
    }
    return "$baseUrl/api/v1/uploads/$path";
  }

  static String url({required String url, Map<String, dynamic>? queryParams}) {
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

  set setauthToken(String key) {
    authToken = key;
  }

  void inialize() {}
  GlobalConfig._();
  static GlobalConfig instance = GlobalConfig._();

  static Dio httpClient = Dio(
    BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );
}
