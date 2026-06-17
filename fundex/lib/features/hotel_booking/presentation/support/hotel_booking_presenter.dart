import 'package:intl/intl.dart';

import '../../domain/entities/hotel_models.dart';

class HotelBookingPresenter {
  HotelBookingPresenter(this.localeName)
    : _shortDateFormat = DateFormat('MM/dd', localeName),
      _amountFormat = NumberFormat.decimalPattern(localeName),
      _currencyFormat = NumberFormat.currency(
        locale: localeName,
        symbol: '¥',
        decimalDigits: 0,
      );

  final String localeName;
  final DateFormat _shortDateFormat;
  final NumberFormat _amountFormat;
  final NumberFormat _currencyFormat;

  String stayRange(HotelSearchCriteria criteria) {
    return '${_shortDateFormat.format(criteria.checkInDate)} - '
        '${_shortDateFormat.format(criteria.checkOutDate)}';
  }

  String price(num? value) {
    if (value == null) {
      return '';
    }
    return _currencyFormat.format(value);
  }

  String amount(num? value) {
    if (value == null) {
      return '';
    }
    return _amountFormat.format(value);
  }
}
