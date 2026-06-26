import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelMemberContactsUseCase {
  const FetchHotelMemberContactsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelMemberContact>> call({required String languageCode}) {
    return _repository.fetchMemberContacts(languageCode: languageCode);
  }
}
