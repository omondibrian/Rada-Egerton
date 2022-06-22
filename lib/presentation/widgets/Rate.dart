import 'package:flutter/material.dart';
import './ratingBar.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final _ratingController = TextEditingController();

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ratings ....';
    }
    return null;
  }

  final double _currentRating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ratingBar(rating: this._currentRating),
              ],
            ),
            Row(
              children: [
                // DefaultInput(
                //   controller: this._ratingController,
                //   hintText: 'Ratings',
                //   icon: Icons.star_border,
                //   validator: validator,
                // ),
              ],
            ),
            Row(
              
              children: [
                // RadaButton(title: 'submit', handleClick: () {}, fill: true),
              ],
            )
          ],
        ),
      ),
    );
  }
}
