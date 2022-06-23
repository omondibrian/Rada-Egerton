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
    final result = await ContentService.getInformationCategory();
    result.fold((data) {
      informationCategory = data;
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });

    final dataResult = await ContentService.getInformation();
    dataResult.fold((data) {
      informationData = data;
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    notifyListeners();
    return _info;
  }
}
