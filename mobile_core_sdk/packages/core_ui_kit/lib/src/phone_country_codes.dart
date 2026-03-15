class PhoneCountryCodeOption {
  const PhoneCountryCodeOption({
    required this.intlTeleCode,
    required this.name,
    required this.shortName,
  });

  final String intlTeleCode;
  final String name;
  final String shortName;

  String get dialLabel => '+$intlTeleCode';
  String get displayLabel => '$name  $shortName';
}

const List<PhoneCountryCodeOption>
phoneCountryCodeOptions = <PhoneCountryCodeOption>[
  PhoneCountryCodeOption(intlTeleCode: '86', name: '中国', shortName: 'CN +86'),
  PhoneCountryCodeOption(intlTeleCode: '81', name: '日本', shortName: 'JP +81'),
  PhoneCountryCodeOption(intlTeleCode: '852', name: '香港', shortName: 'HK +852'),
  PhoneCountryCodeOption(intlTeleCode: '853', name: '澳门', shortName: 'MO +853'),
  PhoneCountryCodeOption(intlTeleCode: '886', name: '台湾', shortName: 'TW +886'),
  PhoneCountryCodeOption(intlTeleCode: '82', name: '韩国', shortName: 'KR +82'),
  PhoneCountryCodeOption(intlTeleCode: '1', name: '北美', shortName: 'US +1'),
  PhoneCountryCodeOption(intlTeleCode: '44', name: '英国', shortName: 'UK +44'),
  PhoneCountryCodeOption(intlTeleCode: '49', name: '德国', shortName: 'DE +49'),
  PhoneCountryCodeOption(intlTeleCode: '33', name: '法国', shortName: 'FR +33'),
  PhoneCountryCodeOption(intlTeleCode: '66', name: '泰国', shortName: 'TH +66'),
  PhoneCountryCodeOption(intlTeleCode: '65', name: '新加坡', shortName: 'SG +65'),
  PhoneCountryCodeOption(intlTeleCode: '60', name: '马来西亚', shortName: 'MY +60'),
  PhoneCountryCodeOption(intlTeleCode: '61', name: '澳大利亚', shortName: 'AU +61'),
  PhoneCountryCodeOption(intlTeleCode: '420', name: '捷克', shortName: 'CZ +420'),
];

PhoneCountryCodeOption phoneCountryCodeOptionByCode(String intlCode) {
  for (final option in phoneCountryCodeOptions) {
    if (option.intlTeleCode == intlCode) {
      return option;
    }
  }
  return PhoneCountryCodeOption(
    intlTeleCode: intlCode,
    name: 'Other',
    shortName: '+$intlCode',
  );
}
