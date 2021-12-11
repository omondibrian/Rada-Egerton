import 'package:flutter/foundation.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:rada_egerton/services/content.service.dart';
import 'package:rada_egerton/utils/main.dart';

class InformationProvider with ChangeNotifier {
  late List<InformationCategory> informationCategory;
  late List<InformationData> informationData;

  InfoMessage? _info;
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

    return _info;
  }
}
