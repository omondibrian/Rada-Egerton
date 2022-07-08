import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';

class Counsellor extends Equatable {
  @override
  List<Object?> get props =>
      [user, rating, isOnline, expertise, counsellorId, schedule];
  final User user;
  final double rating;
  final bool isOnline;
  final String expertise;
  final int counsellorId;
  final List<Schedule> schedule;

  const Counsellor({
    required this.user,
    required this.rating,
    required this.isOnline,
    required this.expertise,
    required this.counsellorId,
    this.schedule = const [],
  });

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json);
    return Counsellor(
      counsellorId: json['counsellorId'] is int
          ? json['counsellorId']
          : int.parse(json['counsellorId']),
      user: user,
      isOnline: json['status'] == "online",
      expertise: json['expertise'],
      rating: double.parse(
        json['rating'].toString(),
      ),
      schedule: json["Schedule"] != null
          ? List<Schedule>.from(
              json["Schedule"].map(
                (s) => Schedule.fromJson(s),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "counsellorId": counsellorId,
      "rating": rating,
      "expertise": expertise,
      "_id": user.id,
      "status": isOnline
    };
  }

  Counsellor copyWith({
    User? user,
    double? rating,
    bool? isOnline,
    String? expertise,
    int? counsellorId,
    List<Schedule>? schedule,
  }) {
    return Counsellor(
        user: user ?? this.user,
        rating: rating ?? this.rating,
        isOnline: isOnline ?? this.isOnline,
        expertise: expertise ?? this.expertise,
        counsellorId: counsellorId ?? this.counsellorId,
        schedule: schedule ?? this.schedule);
  }
}

class Schedule extends Equatable {
  final String day;
  final String activeFrom;
  final String activeTo;
  const Schedule({
    required this.day,
    required this.activeFrom,
    required this.activeTo,
  });

  factory Schedule.fromJson(Map json) {
    return Schedule(
      day: json["day"],
      activeFrom: json["active"]["from"],
      activeTo: json["active"]["to"],
    );
  }
  Map toMap() => {
        "day": day,
        "active": {
          "from": activeFrom,
          "to": activeTo,
        }
      };

  @override
  List<Object?> get props => [day];
}
