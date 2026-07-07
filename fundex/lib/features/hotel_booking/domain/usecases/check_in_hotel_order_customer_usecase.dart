import '../repositories/hotel_booking_repository.dart';

class CheckInHotelOrderCustomerUseCase {
  const CheckInHotelOrderCustomerUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call({
    required String orderId,
    required int checkedIn,
    String? roomId,
  }) {
    return _repository.checkInOrderCustomer(
      orderId: orderId,
      checkedIn: checkedIn,
      roomId: roomId,
    );
  }
}
