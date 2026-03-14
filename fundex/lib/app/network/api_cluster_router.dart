import 'package:core_network/core_network.dart';

class ApiClusterRouter {
  ApiClusterRouter({
    required Dio oaDio,
    required Dio memberDio,
    required Dio hotelDio,
  }) : _oaDio = oaDio,
       _memberDio = memberDio,
       _hotelDio = hotelDio;

  factory ApiClusterRouter.fromClients({
    required CoreHttpClient oaClient,
    CoreHttpClient? memberClient,
    CoreHttpClient? hotelClient,
  }) {
    return ApiClusterRouter(
      oaDio: oaClient.dio,
      memberDio: (memberClient ?? oaClient).dio,
      hotelDio: (hotelClient ?? oaClient).dio,
    );
  }

  final Dio _oaDio;
  final Dio _memberDio;
  final Dio _hotelDio;

  Dio dioForPath(String path) {
    final normalized = path.trim().toLowerCase();
    if (normalized.startsWith('/member/')) {
      return _memberDio;
    }
    if (normalized.startsWith('/hotel/')) {
      return _hotelDio;
    }
    return _oaDio;
  }
}
