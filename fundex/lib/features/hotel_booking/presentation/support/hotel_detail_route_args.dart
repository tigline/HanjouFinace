import '../../domain/entities/hotel_models.dart';

class HotelDetailRouteArgs {
  const HotelDetailRouteArgs({
    required this.criteria,
    required this.buildingCode,
  });

  final HotelSearchCriteria criteria;
  final String buildingCode;
}
