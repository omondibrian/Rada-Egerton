import 'dart:convert';

import 'package:rada_egerton/data/entities/UserDTO.dart';

StudentDto studentDtoFromJson(String str) =>
    StudentDto.fromJson(json.decode(str));

String studentDtotoJson(StudentDto data) => json.encode(data.toMap());

class StudentDto {
  StudentDto({
    required this.user,
  });

  User user;

  factory StudentDto.fromJson(Map<String, dynamic> json) => StudentDto(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "user": user.toMap(),
      };
}
