import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/data/entities/auth_dto.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/complaint_dto.dart';
import 'package:rada_egerton/data/entities/contacts_dto.dart';
import 'package:rada_egerton/data/entities/counsellors_dto.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/entities/news_dto.dart';
import 'package:rada_egerton/data/entities/peer_counsellor_dto.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/entities/user_roles.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/rest/api_endpoints.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'http_client.dart';

class _Users {
  Result register(AuthDTO data) => Http.post(
        ApiEndpoints.REGISTER,
        data.toJson(),
      );
  Result<LoginData> login(String email, String password, ErrorLogger logger) =>
      Http.post(
        ApiEndpoints.LOGIN,
        {'email': email, 'password': password},
        deserializer: (data) => LoginData(
          user: User.fromJson(data["payload"]["user"]),
          authToken: data["payload"]["token"],
        ),
        options: HttpOptions(logger: logger),
      );
  Result<User> profile() => Http.get(
        ApiEndpoints.PROFILE,
        deserializer: (data) => User.fromJson(data["user"]),
      );
  Result<User> profileUpdate(User data) => Http.put(
        ApiEndpoints.PROFILE,
        {'name': data.name, "phone": data.phone},
        deserializer: (data) => User.fromJson(data["user"]),
      );
  Result<User> updateImage(FormData data) => Http.put(
        ApiEndpoints.PROFILE,
        data,
        options: HttpOptions(headers: {
          "Content-type": "multipart/form-data",
        }),
        deserializer: (data) => User.fromJson(data["user"]),
      );
  Result<Iterable<Role>> role(String userId) => Http.get(
        ApiEndpoints.ROLES + userId,
        deserializer: (data) => data["userRole"]["role"].map(
          (r) => Role.fromJson(r),
        ),
      );
  Result storeDeviceToken(String token) => Http.post(
        ApiEndpoints.DEVICE_TOKEN,
        {"token": token},
        options: HttpOptions(shouldRetry: true),
      );
  Result<User> getUser(int userId, {ErrorLogger retryLog}) => Http.get(
        ApiEndpoints.PROFILES+userId.toString(),
        deserializer: (data) => User.fromJson(data["user"]),
      );
  Result<User> queryUser(String email, {ErrorLogger retryLog}) => Http.get(
        ApiEndpoints.QUERY_USER_INFO + email,
        deserializer: (data) => User.fromJson(data["user"]),
      );
}

class _Content {
  Result<List<InformationData>> all() => Http.get(
        ApiEndpoints.CONTENT,
        deserializer: (data) => List<InformationData>.from(
          data["content"].map((item) => InformationData.fromJson(item)),
        ),
      );
  Result<List<InformationCategory>> category() => Http.get(
        ApiEndpoints.CONTENT_CATEGORY,
        deserializer: (data) => List<InformationCategory>.from(
          data["contentCategories"].map((item) => InformationCategory.fromJson(item)),
        ),
      );
  Result<List<Contact>> contacts(ErrorLogger logger) => Http.get(
        ApiEndpoints.CONTACT,
        deserializer: (data) => List<Contact>.from(
          data["contacts"].map((j) => Contact.fromJson(j)),
        ),
        options: HttpOptions(shouldRetry: true, logger: logger),
      );
  Result<NewComplaint> createIssue(Map<String, dynamic> data) => Http.post(
        ApiEndpoints.ISSUE,
        data,
        deserializer: (data) => NewComplaint.fromJson(data["newComplaint"]),
      );
  Result<List<IssueCategory>> issueCategory() => Http.get(
        ApiEndpoints.ISSUE_CATEGORY,
        deserializer: (data) => List<IssueCategory>.from(
          data["issuesCategories"]["issueCategories"]
              .map((j) => IssueCategory.fromJson(j)),
        ),
        options: HttpOptions(shouldRetry: true),
      );
  Result<List<News>> news({ErrorLogger? logger}) => Http.get(
        ApiEndpoints.NEWS,
        deserializer: (data) => List<News>.from(
          data["news"].map((j) => News.fromJson(j)),
        ),
        options: HttpOptions(logger: logger),
      );
}

class _Counselling {
  Result<List<Counsellor>> counselors() => Http.get(
        ApiEndpoints.COUNSELLORS,
        deserializer: (data) => List<Counsellor>.from(
          data["counsellors"].map(
            (counsellor) => Counsellor.fromJson(counsellor),
          ),
        ),
      );
  Result<List<PeerCounsellorDto>> peerCounselors() => Http.get(
        ApiEndpoints.PEER_COUNSELLORS,
        deserializer: (data) => List<PeerCounsellorDto>.from(
          data["counsellors"].map(
            (counsellor) => PeerCounsellorDto.fromJson(counsellor),
          ),
        ),
      );
  Result<List<GroupDTO>> forumns() => Http.get(
        ApiEndpoints.FORUMS,
        deserializer: (data) => List<GroupDTO>.from(
          data["data"]["payload"].map(
            (json) => GroupDTO.fromJson(json),
          ),
        ),
      );
  Result<List<GroupDTO>> userGroups() => Http.get(
        ApiEndpoints.USER_GROUPS,
        deserializer: (data) => List<GroupDTO>.from(
          data["data"]["payload"].map(
            (json) => GroupDTO.fromJson(json),
          ),
        ),
      );
  Result<GroupDTO> subGroup(String userId, String groupId,
          {ErrorLogger? retryLog}) =>
      Http.get(
        "${ApiEndpoints.GROUPS_SUBSCRIBE}$userId/$groupId",
        deserializer: (data) => GroupDTO.fromJson(
          data["data"]["payload"],
        ),
        options: HttpOptions(logger: retryLog),
      );
  Result<GroupDTO> createGroup(FormData data, bool isForumn,
          {ErrorLogger? retryLog}) =>
      Http.post(
        "${ApiEndpoints.COUNSELING}${isForumn ? "forum" : ""}",
        data,
        deserializer: (data) => GroupDTO.fromJson(
          data["data"]["payload"],
        ),
        options: HttpOptions(
          logger: retryLog,
          headers: {"Content-type": "multipart/form-data"},
        ),
      );
  Result<GroupDTO> exitGroup(String groupId, {ErrorLogger? retryLog}) =>
      Http.put(
        ApiEndpoints.COUNSELING + groupId,
        {},
        deserializer: (data) => GroupDTO.fromJson(
          data["data"]["payload"],
        ),
        options: HttpOptions(
          logger: retryLog,
        ),
      );
  Result<GroupDTO> deleteGroup(String groupId, {ErrorLogger? retryLog}) =>
      Http.delete(
        ApiEndpoints.COUNSELING + groupId,
        deserializer: (data) => GroupDTO.fromJson(
          data["data"]["payload"],
        ),
        options: HttpOptions(
          logger: retryLog,
        ),
      );
  Result<InfoMessage> rateCounsellor(String counsellorId, double rate) =>
      Http.post(
        "${ApiEndpoints.COUNSELLOR}rate/$counsellorId",
        {"rate": rate},
        deserializer: (_) =>
            InfoMessage("Rating sucessfuly", MessageType.success),
      );
  Result<InfoMessage> updateSchedule(List<Schedule> schedule,
          {ErrorLogger? retryLog}) =>
      Http.put(
        "${ApiEndpoints.COUNSELLOR}schedule",
        jsonEncode({
          "schedule": schedule.map((s) => s.toMap()).toList(),
        }),
        deserializer: (_) => InfoMessage(
          "Schedule created successfuly",
          MessageType.success,
        ),
      );
}

class _Chat {
  Result<Map<String, List<ChatPayload>>> chats() => Http.get(
        ApiEndpoints.COUNSELING,
        deserializer: (data) {
          return {
            "groupChats": List<ChatPayload>.from(
              data["data"]["payload"]["groupMsgs"]
                  .map((c) => ChatPayload.fromJson(c)),
            ),
            "privateChats": List<ChatPayload>.from(
              data["data"]["payload"]["peerMsgs"]
                  .map((c) => ChatPayload.fromJson(c)),
            )
          };
        },
      );
  Result<ChatPayload> sendPrivateChat(FormData data, ErrorLogger logger) =>
      Http.post(
        ApiEndpoints.PRIVATE_CHAT,
        data,
        options: HttpOptions(
          headers: {"Content-type": "multipart/form-data"},
          shouldRetry: true,
          logger: logger,
        ),
        deserializer: (data) => ChatPayload.fromJson(data["data"]["payload"]),
      );
  Result<ChatPayload> sendGroupChat(FormData data, ErrorLogger logger) =>
      Http.post(
        ApiEndpoints.GROUP_CHAT,
        data,
        options: HttpOptions(
          headers: {"Content-type": "multipart/form-data"},
          shouldRetry: true,
          logger: logger,
        ),
        deserializer: (data) => ChatPayload.fromJson(data["data"]["payload"]),
      );
}

class Client {
  static final users = _Users();
  static final content = _Content();
  static final chat = _Chat();
  static final counselling = _Counselling();
}
