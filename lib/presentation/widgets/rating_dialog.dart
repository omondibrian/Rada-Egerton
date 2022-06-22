import 'package:flutter/material.dart';
import 'package:rada_egerton/data/services/counseling/main.dart';
import 'package:rating_dialog/rating_dialog.dart';

Widget ratingDialog(String counsellorId) {
  return RatingDialog(
    enableComment: false,
    initialRating: 1.0,
    // your app's name?
    title: Text(
      'Rating',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: Text(
      'Tap a star to set your rating.',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
    // your app's logo?
    image: Image.asset(
      "assets/android-icon-192x192-green.png",
      height: 100,
    ),
    submitButtonText: 'Submit',
    onSubmitted: (response) {
      CounselingServiceProvider().rateCounsellor(counsellorId, response.rating);
    },
  );
}
