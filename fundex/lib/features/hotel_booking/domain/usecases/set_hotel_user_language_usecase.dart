import '../repositories/hotel_booking_repository.dart';

class SetHotelUserLanguageUseCase {
  const SetHotelUserLanguageUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<void> call({required String languageCode}) {
    return _repository.setUserLanguage(languageCode: languageCode);
  }
}
