import 'package:equatable/equatable.dart';

class Role {
  String name;
  dynamic id;
  Role(this.name, this.id);
  factory Role.fromJson(json) => Role(
        json["name"],
        json["_id"],
      );
}

class UserRole extends Equatable {
  List<String> roles;
  UserRole(this.roles);
  bool get isCounsellor {
    return roles.contains("COUNSELLOR");
  }

  bool get isPeerCounsellor {
    return roles.contains("PEERCounsellor");
  }

  bool get isStudent {
    return !(isCounsellor || isPeerCounsellor);
  }

  @override
  String toString() {
    return "UserRoles($roles)";
  }

  @override
  List<Object?> get props => [roles];
}
