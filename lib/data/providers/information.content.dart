import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/services/content_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class InformationProvider with ChangeNotifier {
  List<InformationCategory>? informationCategory;
  List<InformationData>? informationData;
  ServiceStatus status = ServiceStatus.initial;

  InformationProvider() {
    init();
  }

  Future<void> init() async {
    if (informationCategory == null) {
      status = ServiceStatus.loading;
      notifyListeners();

      final result = await ContentService.getInformationCategory();
      result.fold(
        (data) {
          informationCategory = data;
          status = ServiceStatus.loadingSuccess;
          notifyListeners();
        },
        (error) {
          status = ServiceStatus.loadingFailure;
          notifyListeners();
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
