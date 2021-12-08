
class UserRole {
  List<String> roles;
  UserRole(this.roles);
  bool get isCounselor {
    return roles.contains("COUNSELLOR");
  }

  bool get isPeerCounselor {
    return roles.contains("PEERCOUNSELLOR");
  }
}
