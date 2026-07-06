import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelTodayCheckInsUseCase {
  const FetchHotelTodayCheckInsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelTodayCheckIn>> call({required String languageCode}) {
    return _repository.fetchTodayCheckIns(languageCode: languageCode);
  }
}
