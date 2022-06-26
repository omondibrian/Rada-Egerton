import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/services/content_service.dart';
import 'package:rada_egerton/data/status.dart';

class InformationProvider with ChangeNotifier {
  List<InformationCategory>? informationCategory;
  List<InformationData>? informationData;
  ServiceStatus status = ServiceStatus.initial;

  InformationProvider() {
    init();
  }

  Future<void> init() async {
    //initialialize data only when null
    if (informationData == null && informationCategory == null) {
      status = ServiceStatus.loading;
      notifyListeners();
      if (informationCategory == null) {
        final result = await ContentService.getInformationCategory();
        result.fold(
          (data) {
            informationCategory = data;
          },
          (error) {},
        );
      }

      if (informationData == null) {
        final dataResult = await ContentService.getInformation();
        dataResult.fold(
          (data) {
            informationData = data;
          },
          (error) {},
        );
      }
      if (informationCategory != null && informationData != null) {
        status = ServiceStatus.loadingSuccess;
      } else {
        status = ServiceStatus.loadingFailure;
      }
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    final result = await ContentService.getInformationCategory();
    result.fold(
      (data) {
        informationCategory = data;
      },
      (error) {},
    );

    final dataResult = await ContentService.getInformation();
    dataResult.fold(
      (data) {
        informationData = data;
      },
      (error) {},
    );
    notifyListeners();
  }
}
