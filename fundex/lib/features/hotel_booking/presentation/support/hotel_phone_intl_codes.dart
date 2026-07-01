const List<String> hotelPhoneIntlCodes = <String>[
  '+81',
  '+86',
  '+853',
  '+886',
  '+82',
  '+1',
  '+44',
  '+49',
  '+33',
  '+66',
  '+65',
  '+60',
  '+61',
  '+420',
];

String? normalizeHotelPhoneIntlCode(String rawCode) {
  final trimmed = rawCode.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  final normalized = trimmed.startsWith('+') ? trimmed : '+$trimmed';
  return hotelPhoneIntlCodes.contains(normalized) ? normalized : null;
}

String resolveHotelPhoneIntlCode(String rawCode) {
  return normalizeHotelPhoneIntlCode(rawCode) ?? hotelPhoneIntlCodes.first;
}
