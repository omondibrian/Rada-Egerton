import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/informationData.dart';
import 'package:rada_egerton/data/services/content.service.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class InformationProvider with ChangeNotifier {
  List<InformationCategory>? informationCategory;
  List<InformationData>? informationData;
  InfoMessage? _info;
  InformationProvider() {
    init();
  }
  Future<InfoMessage?> init() async {
    final _result = await ContentService.getInformationCategory();
    _result.fold((_data) {
      informationCategory = _data;
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });

    final _dataResult = await ContentService.getInformation();
    _dataResult.fold((_data) {
      informationData = _data;
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    notifyListeners();
    return _info;
  }
}