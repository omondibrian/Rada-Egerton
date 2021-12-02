import 'dart:convert';

ComplaintDto complaintDtoFromJson(String str) =>
    ComplaintDto.fromJson(json.decode(str));

String complaintDtoToJson(ComplaintDto data) => json.encode(data.toJson());

class ComplaintDto {
  ComplaintDto({
    required this.newComplaint,
  });

  NewComplaint newComplaint;

  factory ComplaintDto.fromJson(Map<String, dynamic> json) => ComplaintDto(
        newComplaint: NewComplaint.fromJson(json["newComplaint"]),
      );

  Map<String, dynamic> toJson() => {
        "newComplaint": newComplaint.toJson(),
      };
}

class NewComplaint {
  NewComplaint({
    required this.msg,
    required this.newIssue,
  });

  String msg;
  NewIssue newIssue;

  factory NewComplaint.fromJson(Map<String, dynamic> json) => NewComplaint(
        msg: json["msg"],
        newIssue: NewIssue.fromJson(json["newIssue"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "newIssue": newIssue.toJson(),
      };
}

class NewIssue {
  NewIssue({
    required this.id,
    required this.forwardedTo,
    required this.userId,
    required this.name,
    required this.natureOfComplaint,
    required this.status,
    required this.universityId,
    required this.issue,
    required this.issueCategoryId,
  });

  int id;
  String forwardedTo;
  String userId;
  String name;
  String natureOfComplaint;
  String status;
  String universityId;
  String issue;
  String issueCategoryId;

  factory NewIssue.fromJson(Map<String, dynamic> json) => NewIssue(
        id: json["_id"],
        forwardedTo: json["forwardedTo"],
        userId: json["user_id"],
        name: json["name"],
        natureOfComplaint: json["natureOfComplaint"],
        status: json["status"],
        universityId: json["University_id"],
        issue: json["issue"],
        issueCategoryId: json["issueCategoryID"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "forwardedTo": forwardedTo,
        "user_id": userId,
        "name": name,
        "natureOfComplaint": natureOfComplaint,
        "status": status,
        "University_id": universityId,
        "issue": issue,
        "issueCategoryID": issueCategoryId,
      };
}

class IssueCategory {
  int id;
  String name;
  IssueCategory({required this.id, required this.name});
  factory IssueCategory.fromJson(Map<String, dynamic> json) {
    return IssueCategory(id: json["_id"], name: json['name']);
  }
}
