import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelFundBenefitTicketsUseCase {
  const FetchHotelFundBenefitTicketsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelFundBenefitTicket>> call() {
    return _repository.fetchFundBenefitTickets();
  }
}
