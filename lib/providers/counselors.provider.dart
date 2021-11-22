import 'package:flutter/material.dart';

class CounsellorsDTO {
  final String name;
  final double rating;
  final bool isOnline;
  final String expertise;
  final String imgUrl;
  CounsellorsDTO(
      {required this.name,
      required this.rating,
      required this.isOnline,
      required this.expertise,
      required this.imgUrl});
}

class CounsellorsDataSource {
  List<CounsellorsDTO> _counsellors = [
    CounsellorsDTO(
        expertise: 'HIV & AIDS',
        isOnline: true,
        name: 'Nzeli',
        rating: 4.5,
        imgUrl:
            'https://w7.pngwing.com/pngs/402/235/png-transparent-businessperson-computer-icons-avatar-passport-miscellaneous-purple-heroes.png')
  ];

  Future<List<CounsellorsDTO>> fetchCounselors() {
    //TODO:intergrate with api to retrive real data
    return Future.delayed(Duration(seconds: 1), () => this._counsellors);
  }
}

class CounselorProvider with ChangeNotifier {
  var _dataSource = CounsellorsDataSource();
  List<CounsellorsDTO> _counselors = [];
  var _conversations = [
    {
      'urlPath':
          'https://w7.pngwing.com/pngs/402/235/png-transparent-businessperson-computer-icons-avatar-passport-miscellaneous-purple-heroes.png',
      'name': 'Nzeli'
    }
  ];

  List<CounsellorsDTO> get counselors {
    return [...this._counselors];
  }

  get conversations {
    return [...this._conversations];
  }

  getCounsellors() async {
    var result = await this._dataSource.fetchCounselors();
    this._counselors = result;
    notifyListeners();
  }

  getCounselingChats() {
    return [];
  }
}
