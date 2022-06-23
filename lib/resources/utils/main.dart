import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/data/entities/GroupsDTO.dart' as Groups;
import 'package:rada_egerton/resources/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceUtility {
  // late final DataConnectionChecker connection;
  final ImagePicker _imagePicker = ImagePicker();
  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("TOKEN");
    return token;
  }

  static Future<bool> isAuthenticated() async {
    var token = await getAuthToken();
    return token!.isNotEmpty;
  }

  static ErrorMessage handleDioExceptions(DioError e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      return ErrorMessage(
          message: e.response!.data["message"] ?? "An error occured",
          status: e.response!.statusCode.toString());
    } else {
      // Something happened in setting up or sending the request that triggered an Error

    }
    return ErrorMessage(message: e.message, status: "400");
  }

  Future<File> uploadImage() async {
    var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    File imageFile = File(pickedImage!.path);
    return imageFile;
  }
}

class Pusher {
  late PusherClient _pusher;

  Pusher({required String appKey, required String token}) {
    PusherOptions options = PusherOptions(
      // host: BASE_URL,
      cluster: "eu",
      // wsPort: 80,

      encrypted: false,
      auth: PusherAuth(
        "${GlobalConfig.baseUrl}/rada/api/v1/pusher/auth",
        headers: {
          'Authorization': token,
        },
      ),
    );

    _pusher =
        PusherClient(appKey, options, autoConnect: true, enableLogging: false);
  }

  PusherClient getConnection() {
    return _pusher;
  }

  disconnect() {
    _pusher.disconnect();
  }
}

class ErrorMessage {
  String message;
  String status;
  ErrorMessage({required this.message, required this.status});
}

class ForumPayload {
  bool isSubscribed;
  Groups.Payload forum;
  ForumPayload({required this.isSubscribed, required this.forum});
}

enum MessageType { error, info, success }

class InfoMessage {
  String message;
  MessageType messageType;

  InfoMessage(this.message, this.messageType);
}

extension X on InfoMessage {
  Color get messageTypeColor {
    if (messageType == MessageType.success) {
      return Colors.greenAccent;
    }

    return Colors.red[700] ?? Colors.red;
  }
}
