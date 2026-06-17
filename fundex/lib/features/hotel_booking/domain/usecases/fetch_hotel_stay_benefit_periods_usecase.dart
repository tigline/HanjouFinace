import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelStayBenefitPeriodsUseCase {
  const FetchHotelStayBenefitPeriodsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelStayBenefitPeriod>> call() {
    return _repository.fetchStayBenefitPeriods();
  }

  Future<List<HotelStayBenefitPeriod>> forHotel({required String hotelId}) {
    return _repository.fetchStayBenefitPeriodsForHotel(hotelId: hotelId);
  }
}
