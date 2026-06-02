import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class PayHotelOrderUseCase {
  const PayHotelOrderUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelOrderPaymentResult> call({
    required String orderId,
    required String paymentCode,
    required num totalAmount,
    required String languageCode,
    bool isCheck = false,
  }) {
    return _repository.payOrder(
      orderId: orderId,
      paymentCode: paymentCode,
      totalAmount: totalAmount,
      languageCode: languageCode,
      isCheck: isCheck,
    );
  }
}
