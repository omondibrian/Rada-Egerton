import 'package:flutter/material.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rating_dialog/rating_dialog.dart';

class CounsellorRatingDialog extends StatelessWidget {
  final String counsellorId;
  const CounsellorRatingDialog({required this.counsellorId, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      enableComment: false,
      initialRating: 1.0,
      // your app's name?
      title: const Text(
        'Rating',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Image.asset(
        "assets/android-icon-192x192-green.png",
        height: 100,
      ),
      submitButtonText: 'Submit',
      onSubmitted: (response) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const   SnackBar( behavior: SnackBarBehavior.floating, 

            content: Text(
              "Submitting, please wait",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        );
        await CounselingService.rateCounsellor(
          counsellorId,
          response.rating,
        );
      },
    );
  }
}
