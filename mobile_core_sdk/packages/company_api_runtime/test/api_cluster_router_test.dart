import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

void main() {
  group('ApiClusterRouter', () {
    test('routes /member path to member cluster', () {
      final oaDio = Dio();
      final memberDio = Dio();
      final hotelDio = Dio();
      final router = ApiClusterRouter(
        oaDio: oaDio,
        memberDio: memberDio,
        hotelDio: hotelDio,
      );

      expect(router.dioForPath('/member/user/index'), same(memberDio));
    });

    test('routes /hotel path to hotel cluster', () {
      final oaDio = Dio();
      final memberDio = Dio();
      final hotelDio = Dio();
      final router = ApiClusterRouter(
        oaDio: oaDio,
        memberDio: memberDio,
        hotelDio: hotelDio,
      );

      expect(router.dioForPath('/hotel/booking/list'), same(hotelDio));
    });

    test('routes other paths to oa cluster with trim/case normalization', () {
      final oaDio = Dio();
      final memberDio = Dio();
      final hotelDio = Dio();
      final router = ApiClusterRouter(
        oaDio: oaDio,
        memberDio: memberDio,
        hotelDio: hotelDio,
      );

      expect(router.dioForPath('/crowdfunding/project/page'), same(oaDio));
      expect(router.dioForPath(' /MEMBER/profile '), same(memberDio));
    });
  });
}
