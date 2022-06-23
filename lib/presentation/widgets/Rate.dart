import 'package:flutter/material.dart';
import './ratingBar.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ratings ....';
    }
    return null;
  }

  final double _currentRating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ratingBar(rating: _currentRating),
            ],
          ),
          Row(
            children: const [
           
            ],
          ),
          Row(
            
            children: const [
              // RadaButton(title: 'submit', handleClick: () {}, fill: true),
            ],
          )
        ],
      ),
    );
  }
}
