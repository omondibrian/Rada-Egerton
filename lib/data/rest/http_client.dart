part of 'client.dart';

typedef ErrorLogger = Function(String)?;

class HttpOptions extends Options {
  HttpOptions({
    String? method,
    int? sendTimeout,
    int? receiveTimeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
    String? contentType,
    ValidateStatus? validateStatus,
    bool? receiveDataWhenStatusError,
    bool? followRedirects,
    int? maxRedirects,
    RequestEncoder? requestEncoder,
    ResponseDecoder? responseDecoder,
    ListFormat? listFormat,
    int retries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    ErrorLogger logger,
    bool shouldRetry = false,
  }) : super(
          method: method,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
          extra: extra,
          headers: headers,
          responseType: responseType,
          contentType: contentType,
          validateStatus: validateStatus,
          receiveDataWhenStatusError: receiveDataWhenStatusError,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects,
          requestEncoder: requestEncoder,
          responseDecoder: responseDecoder,
          listFormat: listFormat,
        ) {
    this.extra ??= {};
    this.extra!["logger"] = logger;
    this.extra!["retries"] = retries;
    this.extra!["retryDelay"] = retryDelay;
    this.extra!["retry"] = logger != null || shouldRetry;
    this.extra!["attempt"] = 1;
  }
}

class RequestInterceptor extends Interceptor {
  final Dio dio;
  RequestInterceptor({required this.dio});

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    final authToken = AuthenticationProvider.instance.authToken;
    if (authToken.isNotEmpty) {
      options.headers["Authorization"] = authToken;
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      /// LOGOUT the user and clear the auth token
      AuthenticationProvider.instance.logout();
    } else if (_shouldRetry(err)) {
      try {
        final options = err.requestOptions;
        options.extra["logger"]?.call(
          "An error occured, "
          "retrying ${options.extra["attempt"]}/${options.extra["retries"]} "
          "after ${options.extra["retryDelay"].inMilliseconds} ms",
        );
        await Future.delayed(options.extra["retryDelay"]);
        options.extra["attempt"] += 1;
        await dio.fetch(options).then(
              (value) => handler.resolve(value),
            );
      } on DioError catch (e) {
        return super.onError(e, handler);
      }
    }
    super.onError(err, handler);
  }

  bool _shouldRetry(DioError error) {
    int? retries = error.requestOptions.extra["retries"];
    int? attempt = error.requestOptions.extra["attempt"];

    if (error.requestOptions.extra["retry"] != true) return false;
    if (attempt != null && retries != null) {
      if (!(attempt <= retries)) {
        return false;
      }
      return [
            DioErrorType.connectTimeout,
            DioErrorType.sendTimeout,
            DioErrorType.receiveTimeout,
            DioErrorType.other,
          ].contains(error.type) ||
          error is SocketException;
    }
    return false;
  }
}

final Dio dio = Dio(
  BaseOptions(
    baseUrl: GlobalConfig.baseUrl,
    sendTimeout: 300000,
    receiveTimeout: 300000,
    connectTimeout: 10000,
  ),
);

///[Deserializer] takes in data and tranform it to desired type[X]
typedef Deserializer<X> = X Function(dynamic data);
typedef Result<X> = Future<Either<X, ErrorMessage>>;

class Http {
  static final _firebaseCrashlytics = FirebaseCrashlytics.instance;
  static final _httpClient = dio
    ..interceptors.add(
      (RequestInterceptor(dio: dio)),
    );
  static Result<T> get<T>(
    String url, {
    HttpOptions? options,
    Deserializer<T>? deserializer,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _httpClient.get(url,
          options: options, queryParameters: queryParams);
      return Left(
        deserializer != null ? deserializer(res.data) : res.data,
      );
    } catch (error, stackTrace) {
      _firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Error while performing GET on $url',
      );
      return Right(
        handleDioExceptions(error),
      );
    }
  }

  static Result<T> post<T>(
    String url,
    dynamic data, {
    HttpOptions? options,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await _httpClient.post(url, data: data, options: options);
      return Left(
        deserializer != null ? deserializer(res.data) : res.data,
      );
    } catch (error, stackTrace) {
      _firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Error while performing POST on $url',
      );
      return Right(handleDioExceptions(error));
    }
  }

  static Result<T> put<T>(
    String url,
    dynamic data, {
    HttpOptions? options,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await _httpClient.put(url, data: data, options: options);
      return Left(
        deserializer != null ? deserializer(res.data) : res.data,
      );
    } catch (error, stackTrace) {
      _firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Error while performing PUT on $url',
      );
      return Right(handleDioExceptions(error));
    }
  }

  static Result<T> patch<T>(
    String url,
    dynamic data, {
    HttpOptions? options,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await _httpClient.patch(url, data: data, options: options);
      return Left(
        deserializer != null ? deserializer(res.data) : res.data,
      );
    } catch (error, stackTrace) {
      _firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Error while performing PATCH on $url',
      );
      return Right(handleDioExceptions(error));
    }
  }

  static Result<T> delete<T>(
    String url, {
    HttpOptions? options,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await _httpClient.delete(url, options: options);
      return Left(
        deserializer != null ? deserializer(res.data) : res.data,
      );
    } catch (error, stackTrace) {
      _firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Error while performing DELETE on $url',
      );
      return Right(handleDioExceptions(error));
    }
  }
}
