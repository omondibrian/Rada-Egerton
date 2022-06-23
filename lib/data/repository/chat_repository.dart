import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ChatRepository {
  Chats? chats;

  Future<Either<Chats, ErrorMessage>> getChats() async {
    if (chats != null) {
      return Left(chats!);
    }
    try {
      //TODO get chats
      return const Left(
        Chats(),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
