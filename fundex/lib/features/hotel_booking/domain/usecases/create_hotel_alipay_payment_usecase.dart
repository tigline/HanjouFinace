import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class CreateHotelAlipayPaymentUseCase {
  const CreateHotelAlipayPaymentUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelOrderPaymentResult> call({
    required String orderId,
    required String system,
  }) {
    return _repository.createAlipayPayment(orderId: orderId, system: system);
  }
}
