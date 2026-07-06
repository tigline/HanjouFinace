import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/repositories/hotel_booking_repository.dart';
import 'package:fundex/features/hotel_booking/domain/usecases/search_hotels_usecase.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_booking_controller.dart';

void main() {
  group('HotelBookingController', () {
    test('loadMore requests next hotelSearch page and appends rows', () async {
      final repository = _FakeHotelBookingRepository(
        responses: <int, HotelSearchResult>{
          1: HotelSearchResult(
            hotels: <HotelSummary>[_hotel('hotel-1')],
            totalCount: 2,
          ),
          2: HotelSearchResult(
            hotels: <HotelSummary>[_hotel('hotel-2')],
            totalCount: 2,
          ),
        },
      );
      final controller = HotelBookingController(
        searchHotels: SearchHotelsUseCase(repository),
        languageCode: 'ja',
        now: DateTime(2026, 6, 29),
      );

      await _flushMicrotasks();

      expect(controller.state.hotels.map((hotel) => hotel.id), ['hotel-1']);
      expect(controller.state.hasMore, isTrue);
      expect(controller.state.nextPage, 2);

      await controller.loadMore();

      expect(repository.requests.map((request) => request.page), [1, 2]);
      expect(repository.requests.map((request) => request.limit), [9, 9]);
      expect(controller.state.hotels.map((hotel) => hotel.id), [
        'hotel-1',
        'hotel-2',
      ]);
      expect(controller.state.hasMore, isFalse);
      expect(controller.state.nextPage, 3);
    });
  });
}

Future<void> _flushMicrotasks() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

HotelSummary _hotel(String id) {
  return HotelSummary(
    id: id,
    name: id,
    address: '',
    area: '',
    imageUrl: '',
    latitude: null,
    longitude: null,
    lowestPrice: null,
    beforeDiscountPrice: null,
    discount: null,
    discountName: '',
    bookingType: null,
    buildingCode: '',
    bookingTypeLabel: '',
    buildingType: '',
    isBookable: true,
    remainingRooms: null,
    stayBenefitParticipate: false,
    tags: const <String>[],
  );
}

class _FakeHotelBookingRepository implements HotelBookingRepository {
  _FakeHotelBookingRepository({required this.responses});

  final Map<int, HotelSearchResult> responses;
  final List<_HotelSearchRequest> requests = <_HotelSearchRequest>[];

  @override
  Future<HotelSearchResult> searchHotels({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  }) async {
    requests.add(_HotelSearchRequest(page: page, limit: limit));
    return responses[page] ??
        const HotelSearchResult(hotels: <HotelSummary>[], totalCount: 0);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _HotelSearchRequest {
  const _HotelSearchRequest({required this.page, required this.limit});

  final int page;
  final int limit;
}
