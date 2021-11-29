import 'package:dio/dio.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ServiceUtility {
  late final DataConnectionChecker connection;
  static Future<String?> getAuthToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString("TOKEN");
    return token;
  }

  Future<bool> get isConnected => connection.hasConnection;

  static ErrorMessage handleDioExceptions(DioError e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response!.data);
      print(e.response!.requestOptions);
      return ErrorMessage(
          message: e.response!.data, status: e.response!.statusCode.toString());
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
    }
    return ErrorMessage(message: e.message, status: "400");
  }
}

class Pusher {
  late PusherClient _pusher;

  Pusher({required String appKey, required String token}) {
    PusherOptions options = PusherOptions(
      host: BASE_URL,
      wsPort: 80,
      encrypted: false,
      auth: PusherAuth(
        "$BASE_URL/rada/api/v1/pusher/auth",
        headers: {
          'Authorization': "$token",
        },
      ),
    );

    this._pusher = PusherClient(appKey, options, autoConnect: true);
  }

  PusherClient getConnection() {
    return this._pusher;
  }

  disconnect() {
    this._pusher.disconnect();
  }
}

class ErrorMessage {
  String message;
  String status;
  ErrorMessage({required this.message, required this.status});
}
