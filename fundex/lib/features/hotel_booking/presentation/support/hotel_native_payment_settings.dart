import 'package:flutter_riverpod/flutter_riverpod.dart';

class HotelNativePaymentSettings {
  const HotelNativePaymentSettings({
    required this.wechatAppId,
    required this.wechatUniversalLink,
    required this.alipayUniversalLink,
  });

  factory HotelNativePaymentSettings.fromDartDefine() {
    return const HotelNativePaymentSettings(
      wechatAppId: String.fromEnvironment(
        'WECHAT_APP_ID',
        defaultValue: 'wx8c903978efa432d2',
      ),
      wechatUniversalLink: String.fromEnvironment(
        'WECHAT_UNIVERSAL_LINK',
        defaultValue: 'https://gutingjun.com/',
      ),
      alipayUniversalLink: String.fromEnvironment('ALIPAY_UNIVERSAL_LINK'),
    );
  }

  final String wechatAppId;
  final String wechatUniversalLink;
  final String alipayUniversalLink;

  bool get hasWechatConfig =>
      wechatAppId.trim().isNotEmpty && wechatUniversalLink.trim().isNotEmpty;
}

final hotelNativePaymentSettingsProvider = Provider<HotelNativePaymentSettings>(
  (ref) {
    return HotelNativePaymentSettings.fromDartDefine();
  },
);
