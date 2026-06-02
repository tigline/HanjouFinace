import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_booking_payment_section.dart';
import 'hotel_native_payment_service.dart';

Future<void> runHotelNativePaymentFlow({
  required BuildContext context,
  required WidgetRef ref,
  required String orderId,
  required num totalAmount,
  required String languageCode,
  required HotelBookingPaymentMethod paymentMethod,
  VoidCallback? onSuccess,
}) async {
  final orderPayment = await _createNativePaymentOrder(
    context: context,
    ref: ref,
    orderId: orderId,
    totalAmount: totalAmount,
    languageCode: languageCode,
    paymentMethod: paymentMethod,
  );
  if (orderPayment == null) {
    return;
  }
  if (!context.mounted) {
    return;
  }

  if (orderPayment.pay &&
      orderPayment.wechat == null &&
      orderPayment.alipay == null) {
    await _handleNativePaymentResult(
      context: context,
      ref: ref,
      orderId: orderId,
      result: const HotelNativePaymentResult(
        status: HotelNativePaymentStatus.success,
      ),
      syncBackend: false,
      onSuccess: onSuccess,
    );
    return;
  }

  final service = ref.read(hotelNativePaymentServiceProvider);
  final HotelNativePaymentResult result;
  switch (paymentMethod) {
    case HotelBookingPaymentMethod.wechatPay:
      final payload = orderPayment.wechat;
      if (payload == null) {
        AppNotice.show(
          context,
          message: orderPayment.message.isNotEmpty
              ? orderPayment.message
              : context.l10n.hotelPaymentNativePayloadMissing,
        );
        return;
      }
      result = await _runNativePayment(
        context: context,
        action: () => service.payWithWechat(payload),
      );
    case HotelBookingPaymentMethod.alipay:
      final payload = orderPayment.alipay;
      if (payload == null) {
        AppNotice.show(
          context,
          message: orderPayment.message.isNotEmpty
              ? orderPayment.message
              : context.l10n.hotelPaymentNativePayloadMissing,
        );
        return;
      }
      result = await _runNativePayment(
        context: context,
        action: () => service.payWithAlipay(payload),
      );
    case HotelBookingPaymentMethod.creditCard:
      return;
  }

  if (!context.mounted) {
    return;
  }
  await _handleNativePaymentResult(
    context: context,
    ref: ref,
    orderId: orderId,
    result: result,
    syncBackend: result.status != HotelNativePaymentStatus.unavailable,
    onSuccess: onSuccess,
  );
}

Future<HotelOrderPaymentResult?> _createNativePaymentOrder({
  required BuildContext context,
  required WidgetRef ref,
  required String orderId,
  required num totalAmount,
  required String languageCode,
  required HotelBookingPaymentMethod paymentMethod,
}) async {
  try {
    if (paymentMethod == HotelBookingPaymentMethod.alipay) {
      return await ref.read(createHotelAlipayPaymentUseCaseProvider)(
        orderId: orderId,
        system: _nativePaymentSystem(),
      );
    }
    final paymentCode = _paymentCodeForMethod(paymentMethod);
    if (paymentCode == null) {
      AppNotice.show(context, message: context.l10n.hotelPaymentNativeFailed);
      return null;
    }
    return await ref.read(payHotelOrderUseCaseProvider)(
      orderId: orderId,
      paymentCode: paymentCode,
      totalAmount: totalAmount,
      languageCode: languageCode,
    );
  } catch (_) {
    if (context.mounted) {
      AppNotice.show(context, message: context.l10n.hotelPaymentNativeFailed);
    }
    return null;
  }
}

Future<HotelNativePaymentResult> _runNativePayment({
  required BuildContext context,
  required Future<HotelNativePaymentResult> Function() action,
}) async {
  try {
    return await action();
  } catch (_) {
    return HotelNativePaymentResult(
      status: HotelNativePaymentStatus.failure,
      message: context.mounted ? context.l10n.hotelPaymentNativeFailed : '',
    );
  }
}

Future<void> _handleNativePaymentResult({
  required BuildContext context,
  required WidgetRef ref,
  required String orderId,
  required HotelNativePaymentResult result,
  required bool syncBackend,
  VoidCallback? onSuccess,
}) async {
  if (syncBackend) {
    try {
      await ref.read(syncHotelOptimismPaymentUseCaseProvider)(
        orderId: orderId,
        success: result.isSuccess,
      );
    } catch (_) {
      // Order status refresh below remains the user-visible source of truth.
    }
  }

  ref.invalidate(hotelOrderDetailProvider(orderId));
  ref.invalidate(hotelOrderListControllerProvider);

  if (!context.mounted) {
    return;
  }
  switch (result.status) {
    case HotelNativePaymentStatus.success:
      AppNotice.show(context, message: context.l10n.hotelPaymentNativeSuccess);
      onSuccess?.call();
    case HotelNativePaymentStatus.cancelled:
      AppNotice.show(
        context,
        message: context.l10n.hotelPaymentNativeCancelled,
      );
    case HotelNativePaymentStatus.unavailable:
      AppNotice.show(
        context,
        message: _localizedUnavailableMessage(context, result.message),
      );
    case HotelNativePaymentStatus.failure:
      AppNotice.show(
        context,
        message: result.message.isNotEmpty
            ? result.message
            : context.l10n.hotelPaymentNativeFailed,
      );
  }
}

String? _paymentCodeForMethod(HotelBookingPaymentMethod method) {
  return switch (method) {
    HotelBookingPaymentMethod.wechatPay => '14',
    HotelBookingPaymentMethod.alipay => null,
    HotelBookingPaymentMethod.creditCard => null,
  };
}

String _nativePaymentSystem() {
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.iOS => _isIpadDisplay() ? 'ipad' : 'iphone',
    TargetPlatform.macOS => 'ipad',
    _ => 'android',
  };
}

bool _isIpadDisplay() {
  final views = PlatformDispatcher.instance.views;
  if (views.isEmpty) {
    return false;
  }
  final view = views.first;
  final shortestSide = view.physicalSize.shortestSide / view.devicePixelRatio;
  return shortestSide >= 600;
}

String _localizedUnavailableMessage(BuildContext context, String message) {
  if (message.contains('WeChat payment config')) {
    return context.l10n.hotelPaymentNativeConfigMissing;
  }
  if (message.contains('WeChat is not installed')) {
    return context.l10n.hotelPaymentWechatNotInstalled;
  }
  if (message.contains('Alipay is not installed')) {
    return context.l10n.hotelPaymentAlipayNotInstalled;
  }
  return context.l10n.hotelPaymentNativeFailed;
}
