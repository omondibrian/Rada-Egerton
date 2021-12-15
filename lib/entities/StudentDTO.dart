import 'dart:convert';

import 'package:rada_egerton/entities/UserDTO.dart';

StudentDto studentDtoFromJson(String str) =>
    StudentDto.fromJson(json.decode(str));

String studentDtoToJson(StudentDto data) => json.encode(data.toJson());

class StudentDto {
  StudentDto({
    required this.user,
  });

  User user;

  factory StudentDto.fromJson(Map<String, dynamic> json) => StudentDto(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

