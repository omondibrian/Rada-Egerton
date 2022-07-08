import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/resources/config.dart';

class ServiceUtility {
  final ImagePicker _imagePicker = ImagePicker();

  static ErrorMessage handleDioExceptions(error) {
    try {
      if (error is Exception) {
        if (error is SocketException) {
          return const ErrorMessage(
              message: "SocketException",
              status: "Please check your internet connection");
        }
        if (error is DioError) {
          if (error.response != null && error.response!.data != null) {
            return ErrorMessage(
              message: error.response!.data["msg"]?.toString() ??
                  error.response!.data.toString(),
              status: "DioError",
            );
          }
          switch (error.type) {
            case DioErrorType.cancel:
              return const ErrorMessage(
                  message: "Request cancelled", status: "Request cancelled");
            case DioErrorType.connectTimeout:
              return const ErrorMessage(
                  message: "Timeout", status: "Connection timeout exceeded");
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 400:
                  return const ErrorMessage(
                      message: "Client error", status: "Bad Request");
                case 401:
                  return const ErrorMessage(
                      message: "Client error", status: "Unauthorized");
                case 403:
                  return const ErrorMessage(
                      message: "Client error", status: "Forbidden");
                case 404:
                  return const ErrorMessage(
                      message: "Client error",
                      status: "Server resource not found");
                case 500:
                  return const ErrorMessage(
                      message: "Server error", status: "Internal sever error");
              }
              break;
            case DioErrorType.sendTimeout:
              return const ErrorMessage(
                  message: "Request timeout", status: "Request timeout");

            case DioErrorType.receiveTimeout:
              return const ErrorMessage(
                  message: "Request timeout", status: "Request timeout");
            case DioErrorType.other:
              return const ErrorMessage(
                  message: "Error", status: "Unexpected error occured");
          }
        }
      }
      return ErrorMessage(
        message: error.toString(),
        status: "Unexpected error",
      );
    } catch (_) {
      return const ErrorMessage(
        message: "Unexpected error",
        status: "Unexpected error",
      );
    }
  }

  Future<File?> uploadImage() async {
    var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
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

class ErrorMessage extends Equatable {
  @override
  List<Object?> get props => [message, status];
  final String message;
  final String status;
  const ErrorMessage({required this.message, required this.status});
  @override
  String toString() => "ErrorMessage(message: $message, status:$status ) ";
}

enum MessageType { error, info, success }

class InfoMessage {
  String message;
  MessageType messageType;

  InfoMessage(this.message, this.messageType);
  @override
  String toString() {
    return message;
  }

  factory InfoMessage.fromError(ErrorMessage message) {
    return InfoMessage(message.message, MessageType.error);
  }
}

extension X on InfoMessage {
  Color get messageTypeColor {
    if (messageType == MessageType.success) {
      return Colors.greenAccent;
    }

    return Colors.red[700] ?? Colors.red;
  }
   TextStyle get style {
    return TextStyle(color: messageTypeColor);
  }
}
