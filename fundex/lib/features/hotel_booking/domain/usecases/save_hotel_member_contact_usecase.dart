import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class SaveHotelMemberContactUseCase {
  const SaveHotelMemberContactUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<void> call(HotelMemberContactDraft draft) {
    return _repository.saveMemberContact(draft);
  }
}
