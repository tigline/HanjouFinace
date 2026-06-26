import '../repositories/hotel_booking_repository.dart';

class DeleteHotelMemberContactUseCase {
  const DeleteHotelMemberContactUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<void> call({required String id}) {
    return _repository.deleteMemberContact(id: id);
  }
}
