import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';

import '../observability/app_observability_providers.dart';

class AppObservabilityInterceptor extends Interceptor {
  AppObservabilityInterceptor({
    required AppLogger logger,
    required void Function(AppUiMessageKey messageKey) reportErrorMessage,
  }) : _logger = logger,
       _reportErrorMessage = reportErrorMessage;

  final AppLogger _logger;
  final void Function(AppUiMessageKey messageKey) _reportErrorMessage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug(
      'HTTP request',
      context: <String, Object?>{
        'method': options.method,
        'path': options.path,
      },
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      'HTTP response',
      context: <String, Object?>{
        'method': response.requestOptions.method,
        'path': response.requestOptions.path,
        'statusCode': response.statusCode,
      },
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = err.error;
    if (failure is NetworkFailure) {
      _logger.error(
        'HTTP failure',
        error: failure,
        stackTrace: err.stackTrace,
        context: <String, Object?>{
          'method': err.requestOptions.method,
          'path': err.requestOptions.path,
          'statusCode': failure.statusCode,
          'failureType': failure.type.name,
        },
      );

      final userMessage = _mapUserMessage(failure);
      if (userMessage != null) {
        _reportErrorMessage(userMessage);
      }
      handler.next(err);
      return;
    }

    _logger.error(
      'Unexpected dio error',
      error: err.error ?? err.message,
      stackTrace: err.stackTrace,
      context: <String, Object?>{
        'method': err.requestOptions.method,
        'path': err.requestOptions.path,
      },
    );
    _reportErrorMessage(AppUiMessageKey.requestFailed);
    handler.next(err);
  }

  AppUiMessageKey? _mapUserMessage(NetworkFailure failure) {
    switch (failure.type) {
      case NetworkFailureType.cancelled:
        return null;
      case NetworkFailureType.connectionTimeout:
      case NetworkFailureType.sendTimeout:
      case NetworkFailureType.receiveTimeout:
      case NetworkFailureType.connectionError:
        return AppUiMessageKey.networkUnavailable;
      case NetworkFailureType.unauthorized:
        return AppUiMessageKey.authExpired;
      case NetworkFailureType.forbidden:
        return AppUiMessageKey.forbidden;
      case NetworkFailureType.serverError:
        return AppUiMessageKey.serverUnavailable;
      case NetworkFailureType.badCertificate:
      case NetworkFailureType.badResponse:
      case NetworkFailureType.unknown:
        return AppUiMessageKey.requestFailed;
    }
  }
}
