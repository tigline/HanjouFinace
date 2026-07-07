import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../../../hotel_booking/presentation/providers/hotel_booking_providers.dart';

class HomeFeaturedHotels {
  const HomeFeaturedHotels({required this.criteria, required this.hotels});

  final HotelSearchCriteria criteria;
  final List<HotelSummary> hotels;
}

final homeFeaturedHotelsProvider =
    FutureProvider.autoDispose<HomeFeaturedHotels>((ref) async {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      final criteria = HotelSearchCriteria.initial(DateTime.now());
      final result = await ref.watch(searchHotelsUseCaseProvider)(
        criteria: criteria,
        languageCode: languageCode,
        page: 1,
        limit: 4,
      );
      return HomeFeaturedHotels(
        criteria: criteria,
        hotels: result.hotels.take(4).toList(growable: false),
      );
    });
