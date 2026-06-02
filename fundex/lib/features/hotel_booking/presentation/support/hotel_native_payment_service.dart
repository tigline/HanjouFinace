import 'dart:async';

import 'package:alipay_payment/alipay_payment.dart';
import 'package:fluwx/fluwx.dart';

import '../../domain/entities/hotel_models.dart';
import 'hotel_native_payment_settings.dart';

enum HotelNativePaymentStatus { success, failure, cancelled, unavailable }

class HotelNativePaymentResult {
  const HotelNativePaymentResult({required this.status, this.message = ''});

  final HotelNativePaymentStatus status;
  final String message;

  bool get isSuccess => status == HotelNativePaymentStatus.success;
}

class HotelNativePaymentService {
  HotelNativePaymentService({required HotelNativePaymentSettings settings})
    : _settings = settings;

  final HotelNativePaymentSettings _settings;
  final Fluwx _fluwx = Fluwx();
  bool _wechatRegistered = false;

  Future<bool> get isWechatInstalled => _fluwx.isWeChatInstalled;

  Future<bool> get isAlipayInstalled {
    return AlipayPaymentPlatform.instance.isAlipayInstalled();
  }

  Future<HotelNativePaymentResult> payWithWechat(
    HotelWechatPaymentPayload payload,
  ) async {
    if (!_settings.hasWechatConfig) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.unavailable,
        message: 'WeChat payment config is missing.',
      );
    }
    if (!_isValidWechatPayload(payload)) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.failure,
        message: 'WeChat payment payload is incomplete.',
      );
    }
    if (!await isWechatInstalled) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.unavailable,
        message: 'WeChat is not installed.',
      );
    }
    if (!_wechatRegistered) {
      _wechatRegistered = await _fluwx.registerApi(
        appId: _settings.wechatAppId.trim(),
        universalLink: _settings.wechatUniversalLink.trim(),
      );
    }
    if (!_wechatRegistered) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.failure,
        message: 'Failed to register WeChat payment API.',
      );
    }

    final completer = Completer<HotelNativePaymentResult>();
    final subscription = _fluwx.addSubscriber((response) {
      if (response is! WeChatPaymentResponse || completer.isCompleted) {
        return;
      }
      completer.complete(_wechatResultFromResponse(response));
    });

    try {
      final launched = await _fluwx.pay(
        which: Payment(
          appId: payload.appId,
          partnerId: payload.partnerId,
          prepayId: payload.prepayId,
          packageValue: payload.packageValue,
          nonceStr: payload.nonceStr,
          timestamp: payload.timestamp ?? 0,
          sign: payload.paySign,
          signType: payload.signType.isEmpty ? null : payload.signType,
        ),
      );
      if (!launched) {
        return const HotelNativePaymentResult(
          status: HotelNativePaymentStatus.failure,
          message: 'Failed to launch WeChat payment.',
        );
      }
      return await completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () => const HotelNativePaymentResult(
          status: HotelNativePaymentStatus.failure,
          message: 'WeChat payment timed out.',
        ),
      );
    } finally {
      subscription.cancel();
    }
  }

  Future<HotelNativePaymentResult> payWithAlipay(
    HotelAlipayPaymentPayload payload,
  ) async {
    if (payload.orderInfo.trim().isEmpty) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.failure,
        message: 'Alipay payment payload is incomplete.',
      );
    }
    if (!await isAlipayInstalled) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.unavailable,
        message: 'Alipay is not installed.',
      );
    }
    final result = await AlipayPaymentPlatform.instance.payAndWait(
      orderInfo: payload.orderInfo,
      universalLink: _settings.alipayUniversalLink.trim().isEmpty
          ? null
          : _settings.alipayUniversalLink.trim(),
    );
    if (result.isSuccess) {
      return const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.success,
      );
    }
    if (result.isCancel) {
      return HotelNativePaymentResult(
        status: HotelNativePaymentStatus.cancelled,
        message: result.memo ?? '',
      );
    }
    return HotelNativePaymentResult(
      status: HotelNativePaymentStatus.failure,
      message: result.memo ?? result.resultStatus,
    );
  }

  bool _isValidWechatPayload(HotelWechatPaymentPayload payload) {
    return payload.appId.isNotEmpty &&
        payload.partnerId.isNotEmpty &&
        payload.prepayId.isNotEmpty &&
        payload.packageValue.isNotEmpty &&
        payload.nonceStr.isNotEmpty &&
        payload.paySign.isNotEmpty &&
        payload.timestamp != null;
  }

  HotelNativePaymentResult _wechatResultFromResponse(
    WeChatPaymentResponse response,
  ) {
    return switch (response.errCode) {
      0 => const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.success,
      ),
      -2 => HotelNativePaymentResult(
        status: HotelNativePaymentStatus.cancelled,
        message: response.errStr ?? '',
      ),
      _ => HotelNativePaymentResult(
        status: HotelNativePaymentStatus.failure,
        message: response.errStr ?? response.errCode.toString(),
      ),
    };
  }
}
