import 'package:equatable/equatable.dart';

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
