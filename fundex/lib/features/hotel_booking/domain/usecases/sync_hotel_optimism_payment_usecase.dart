import '../repositories/hotel_booking_repository.dart';

class SyncHotelOptimismPaymentUseCase {
  const SyncHotelOptimismPaymentUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call({required String orderId, required bool success}) {
    return _repository.syncOptimismPayment(orderId: orderId, success: success);
  }
}
