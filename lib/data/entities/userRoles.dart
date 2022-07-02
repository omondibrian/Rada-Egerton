import 'package:equatable/equatable.dart';

class UserRole extends Equatable {
  List<String> roles;
  UserRole(this.roles);
  bool get isCounsellor {
    return roles.contains("Counsellor");
  }

  bool get isPeerCounsellor {
    return roles.contains("PEERCounsellor");
  }

  bool get isStudent {
    return !(this.isCounsellor || this.isPeerCounsellor);
  }

  @override
  List<Object?> get props => [roles];
}
