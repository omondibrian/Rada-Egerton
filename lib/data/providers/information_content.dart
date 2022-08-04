import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/rest/client.dart';
import 'package:rada_egerton/data/status.dart';

class InformationProvider with ChangeNotifier {
  List<InformationCategory>? informationCategory;
  List<InformationData>? informationData;
  ServiceStatus status = ServiceStatus.initial;

  InformationProvider() {
    init();
  }

  Future<void> init() async {
    status = ServiceStatus.loading;
    notifyListeners();
    if (informationData == null && informationCategory == null) {
      if (informationCategory == null) {
        final result = await Client.content.category();
        result.fold(
          (data) {
            informationCategory = data;
          },
          (error) {},
        );
      }

      if (informationData == null) {
        final dataResult = await Client.content.all();
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
    final result = await Client.content.category();
    result.fold(
      (data) {
        informationCategory = data;
      },
      (error) {},
    );

    final dataResult = await Client.content.all();
    dataResult.fold(
      (data) {
        informationData = data;
      },
      (error) {},
    );
    notifyListeners();
  }
}
