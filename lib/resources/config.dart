import 'package:dio/dio.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';

class GlobalConfig {
  String pusherApiKey = "8da328d2097b06731d0a";
  static String baseUrl = "http://192.168.90.100";
  String appKey = "";
  String authToken = "";
  User user = User.empty();

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
