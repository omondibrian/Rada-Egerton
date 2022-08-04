
/// Singleton class to store Global configuration variables
class GlobalConfig {
  static String baseUrl = "https://radaegerton.ddns.net";

  ///placeholder user image
  static String userAvi =
      "https://img.icons8.com/ios-glyphs/90/000000/user--v1.png";

  ///placeholder users image
  static String usersAvi =
      "https://img.icons8.com/ios-glyphs/90/000000/group.png";

  ///Intitialile or set [GlobalConfiguration] variable
  void inialize() {}

  GlobalConfig._();
  static GlobalConfig instance = GlobalConfig._();
}

///Create absolute image url
String imageUrl(String path) {
  if (path.startsWith("/")) {
    return "${GlobalConfig.baseUrl}/api/v1/uploads$path";
  }
  return "${GlobalConfig.baseUrl}/api/v1/uploads/$path";
}

///Create an absulute url by concatinating Server host url and give parameters
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
