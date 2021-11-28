import 'package:dio/dio.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/services/utils.dart';

class IssueServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();
  final _timeOut = 10000;

  CreateNewIssue() async {
 try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/news",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: this._timeOut),
          );
      return NewsDto.fromJson(result.data);
    } on DioError catch (e) {
      ServiceUtility.handleDioExceptions(e);
    }

  }
}
