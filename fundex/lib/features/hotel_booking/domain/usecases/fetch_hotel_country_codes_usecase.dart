import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelCountryCodesUseCase {
  const FetchHotelCountryCodesUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelCountryCode>> call({required String languageCode}) {
    return _repository.fetchCountryCodes(languageCode: languageCode);
  }
}
