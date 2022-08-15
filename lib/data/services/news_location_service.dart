import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/entities/location_dto.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class NewsAndLocationServiceProvider {
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  Future<Either<List<Location>, ErrorMessage>> fetchLocationPins() async {
    String? authtoken = AuthenticationProvider.instance.authToken;
    try {
      final result = await rootBundle.loadString('assets/locations.json');
      return Left(List<Location>.from(
              jsonDecode(result)["locations"].map((l) => Location.fromJson(l)))
          //todo: revert this too
          // result.data,
          );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching location pins',
      );
      return Right(
        handleDioExceptions(e),
      );
    }
  }
}
