import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelPriceDiscountUseCase {
  const FetchHotelPriceDiscountUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelPriceDiscount> call({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required String languageCode,
  }) {
    return _repository.fetchPriceDiscount(
      hotelId: hotelId,
      criteria: criteria,
      languageCode: languageCode,
    );
  }
}
