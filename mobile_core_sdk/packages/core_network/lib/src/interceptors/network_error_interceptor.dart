import 'package:dio/dio.dart';

import '../models/network_failure.dart';

class NetworkErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is NetworkFailure) {
      handler.next(err);
      return;
    }

    final mappedFailure = mapDioExceptionToFailure(err);
    final mapped = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: mappedFailure,
      message: err.message,
      stackTrace: err.stackTrace,
    );
    handler.next(mapped);
  }
}
