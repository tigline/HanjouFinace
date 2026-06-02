import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelMemberPayInfoUseCase {
  const FetchHotelMemberPayInfoUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelMemberPayInfo> call() {
    return _repository.fetchMemberPayInfo();
  }
}
