import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/informationData.dart';
import 'package:rada_egerton/data/services/content_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class InformationProvider with ChangeNotifier {
  List<InformationCategory>? informationCategory;
  List<InformationData>? informationData;
  ServiceStatus status = ServiceStatus.initial;

  // InformationProvider() {
  //   init();
  // }

  Future<void> init() async {
    if (informationCategory == null) {
      status = ServiceStatus.loading;
      notifyListeners();

      final result = await ContentService.getInformationCategory();
      result.fold(
        (data) {
          informationCategory = data;
          notifyListeners();
        },
        (error) {
          throw (InfoMessage(error.message, MessageType.error));
        },
      );
    }

    if (informationData == null) {
      status = ServiceStatus.loading;
      notifyListeners();
      final dataResult = await ContentService.getInformation();
      dataResult.fold(
        (data) {
          informationData = data;
          notifyListeners();
        },
        (error) {
          throw (InfoMessage(error.message, MessageType.error));
        },
      );
    }
    if (informationCategory != null && informationData != null) {
      status = ServiceStatus.loadingSuccess;
      notifyListeners();
    }
  }
}
