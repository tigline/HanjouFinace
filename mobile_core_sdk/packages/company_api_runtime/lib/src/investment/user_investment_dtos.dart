class UserInvestmentAccountStatisticDto {
  const UserInvestmentAccountStatisticDto({
    this.userId,
    this.total,
    this.crowdfundingTotal,
    this.financialTotal,
    this.firstLevelAccountTotal,
  });

  factory UserInvestmentAccountStatisticDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserInvestmentAccountStatisticDto(
      userId: _intOrNull(json['userId']),
      total: _numOrNull(json['total']),
      crowdfundingTotal: _numOrNull(json['crowdfundingTotal']),
      financialTotal: _numOrNull(json['financialTotal']),
      firstLevelAccountTotal: _numOrNull(json['firstLevelAccountTotal']),
    );
  }

  final int? userId;
  final num? total;
  final num? crowdfundingTotal;
  final num? financialTotal;
  final num? firstLevelAccountTotal;
}

class UserInvestmentInvestorTypeDto {
  const UserInvestmentInvestorTypeDto({
    this.id,
    this.projectId,
    this.investorType,
    this.investorCode,
    this.earningsType,
    this.earningsRadio,
    this.interestRadio,
    this.remark,
    this.isOpen,
    this.isOpenType,
  });

  factory UserInvestmentInvestorTypeDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentInvestorTypeDto(
      id: _stringOrNull(json['id']),
      projectId: _stringOrNull(json['projectId']),
      investorType: _stringOrNull(json['investorType']),
      investorCode: _stringOrNull(json['investorCode']),
      earningsType: _stringOrNull(json['earningsType']),
      earningsRadio: _doubleOrNull(json['earningsRadio']),
      interestRadio: _doubleOrNull(json['interestRadio']),
      remark: _stringOrNull(json['remark']),
      isOpen: _boolOrNull(json['isOpen']),
      isOpenType: _intOrNull(json['isOpenType']),
    );
  }

  final String? id;
  final String? projectId;
  final String? investorType;
  final String? investorCode;
  final String? earningsType;
  final double? earningsRadio;
  final double? interestRadio;
  final String? remark;
  final bool? isOpen;
  final int? isOpenType;
}

class UserInvestmentPdfUrlDto {
  const UserInvestmentPdfUrlDto({this.name, this.url, this.createTime});

  factory UserInvestmentPdfUrlDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentPdfUrlDto(
      name: _stringOrNull(json['name']),
      url: _stringOrNull(json['url']),
      createTime: _stringOrNull(json['createTime']),
    );
  }

  final String? name;
  final String? url;
  final String? createTime;
}

class UserInvestmentPdfDocumentDto {
  const UserInvestmentPdfDocumentDto({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <UserInvestmentPdfUrlDto>[],
  });

  factory UserInvestmentPdfDocumentDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentPdfDocumentDto(
      projectId: _stringOrNull(json['projectId']),
      type: _intOrNull(json['type']),
      description: _stringOrNull(json['desc']),
      urls: _toList(json['urls'])
          .map((dynamic item) {
            if (item is String) {
              return UserInvestmentPdfUrlDto(url: item);
            }
            return UserInvestmentPdfUrlDto.fromJson(_toJsonMap(item));
          })
          .toList(growable: false),
    );
  }

  final String? projectId;
  final int? type;
  final String? description;
  final List<UserInvestmentPdfUrlDto> urls;
}

class UserInvestmentApplyRecordDto {
  const UserInvestmentApplyRecordDto({
    this.projectId,
    this.secondaryMarketSellId,
    this.fromProcessId,
    this.investorCode,
    this.investorType,
    required this.projectName,
    this.memberId,
    this.accountId,
    this.memberName,
    this.status,
    this.applyNum,
    this.applyMoney,
    this.feeRatio,
    this.sellerFeeRatio,
    this.applyTime,
    this.passNum,
    this.passMoney,
    this.passTime,
    this.actualArrivalTime,
    this.investNum,
    this.investMoney,
    this.processId,
    this.serviceFee,
  });

  factory UserInvestmentApplyRecordDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentApplyRecordDto(
      projectId:
          _stringOrNull(json['projectId']) ?? _stringOrNull(json['projecId']),
      secondaryMarketSellId: _stringOrNull(json['secondaryMarketSellId']),
      fromProcessId: _stringOrNull(json['fromProcessId']),
      investorCode: _stringOrNull(json['investorCode']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : UserInvestmentInvestorTypeDto.fromJson(
              _toJsonMap(json['investorType']),
            ),
      projectName: _stringOrNull(json['projectName']) ?? '',
      memberId: _intOrNull(json['memberId']),
      accountId: _stringOrNull(json['accountId']),
      memberName: _stringOrNull(json['memberName']),
      status: _intOrNull(json['status']),
      applyNum: _intOrNull(json['applyNum']),
      applyMoney: _numOrNull(json['applyMoney']),
      feeRatio: _doubleOrNull(json['feeRatio']),
      sellerFeeRatio: _doubleOrNull(json['sellerFeeRatio']),
      applyTime: _stringOrNull(json['applyTime']),
      passNum: _intOrNull(json['passNum']),
      passMoney: _numOrNull(json['passMoney']),
      passTime: _stringOrNull(json['passTime']),
      actualArrivalTime: _stringOrNull(json['actualArrivalTime']),
      investNum: _intOrNull(json['investNum']),
      investMoney: _numOrNull(json['investMoney']),
      processId: _stringOrNull(json['processId']),
      serviceFee: _numOrNull(json['serviceFee']),
    );
  }

  final String? projectId;
  final String? secondaryMarketSellId;
  final String? fromProcessId;
  final String? investorCode;
  final UserInvestmentInvestorTypeDto? investorType;
  final String projectName;
  final int? memberId;
  final String? accountId;
  final String? memberName;
  final int? status;
  final int? applyNum;
  final num? applyMoney;
  final double? feeRatio;
  final double? sellerFeeRatio;
  final String? applyTime;
  final int? passNum;
  final num? passMoney;
  final String? passTime;
  final String? actualArrivalTime;
  final int? investNum;
  final num? investMoney;
  final String? processId;
  final num? serviceFee;
}

class UserInvestmentOrderInquiryRecordDto {
  const UserInvestmentOrderInquiryRecordDto({
    this.id,
    this.memberId,
    this.fromProcessId,
    this.investorType,
    required this.projectName,
    this.sellNum,
    this.soldNum,
    this.price,
    this.status,
    this.createTime,
    this.updateTime,
    this.pdfDocuments = const <UserInvestmentPdfDocumentDto>[],
  });

  factory UserInvestmentOrderInquiryRecordDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserInvestmentOrderInquiryRecordDto(
      id: _stringOrNull(json['id']),
      memberId: _intOrNull(json['memberId']),
      fromProcessId: _stringOrNull(json['fromProcessId']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : UserInvestmentInvestorTypeDto.fromJson(
              _toJsonMap(json['investorType']),
            ),
      projectName: _stringOrNull(json['projectName']) ?? '',
      sellNum: _intOrNull(json['sellNum']),
      soldNum: _intOrNull(json['soldNum']),
      price: _numOrNull(json['price']),
      status: _stringOrNull(json['status']),
      createTime: _stringOrNull(json['createTime']),
      updateTime: _stringOrNull(json['updateTime']),
      pdfDocuments: _toList(json['pdfs'])
          .map(
            (dynamic item) =>
                UserInvestmentPdfDocumentDto.fromJson(_toJsonMap(item)),
          )
          .toList(growable: false),
    );
  }

  final String? id;
  final int? memberId;
  final String? fromProcessId;
  final UserInvestmentInvestorTypeDto? investorType;
  final String projectName;
  final int? sellNum;
  final int? soldNum;
  final num? price;
  final String? status;
  final String? createTime;
  final String? updateTime;
  final List<UserInvestmentPdfDocumentDto> pdfDocuments;
}

class UserInvestmentRecordDto {
  const UserInvestmentRecordDto({
    required this.projectId,
    required this.projectName,
    this.processId,
    this.investNum,
    this.investMoney,
    this.investNumValid,
    this.investMoneyValid,
    this.investNumRemaining,
    this.status,
    this.projectStatus,
    this.createTime,
    this.withdrawalTime,
    this.investorCode,
    this.earningType,
    this.earningRadio,
    this.remark,
    this.memberId,
    this.accountId,
    this.memberName,
    this.earnings,
    this.checkTimes,
    this.investorType,
  });

  factory UserInvestmentRecordDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentRecordDto(
      projectId: _stringOrNull(json['projectId']) ?? '',
      projectName: _stringOrNull(json['projectName']) ?? '',
      processId: _stringOrNull(json['processId']),
      investNum: _intOrNull(json['investNum']),
      investMoney: _numOrNull(json['investMoney']),
      investNumValid: _intOrNull(json['investNumValid']),
      investMoneyValid: _numOrNull(json['investMoneyValid']),
      investNumRemaining: _intOrNull(json['investNumRemaining']),
      status: _intOrNull(json['status']),
      projectStatus: _intOrNull(json['projectStatus']),
      createTime: _stringOrNull(json['createTime']),
      withdrawalTime: _stringOrNull(json['withdrawalTime']),
      investorCode: _stringOrNull(json['investorCode']),
      earningType: _stringOrNull(json['earningType']),
      earningRadio: _doubleOrNull(json['earningRadio']),
      remark: _stringOrNull(json['remark']),
      memberId: _intOrNull(json['memberId']),
      accountId: _stringOrNull(json['accountId']),
      memberName: _stringOrNull(json['memberName']),
      earnings: _numOrNull(json['earnings']),
      checkTimes: _intOrNull(json['checkTimes']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : UserInvestmentInvestorTypeDto.fromJson(
              _toJsonMap(json['investorType']),
            ),
    );
  }

  final String projectId;
  final String projectName;
  final String? processId;
  final int? investNum;
  final num? investMoney;
  final int? investNumValid;
  final num? investMoneyValid;
  final int? investNumRemaining;
  final int? status;
  final int? projectStatus;
  final String? createTime;
  final String? withdrawalTime;
  final String? investorCode;
  final String? earningType;
  final double? earningRadio;
  final String? remark;
  final int? memberId;
  final String? accountId;
  final String? memberName;
  final num? earnings;
  final int? checkTimes;
  final UserInvestmentInvestorTypeDto? investorType;
}

Map<String, dynamic> _toJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  return <String, dynamic>{};
}

Map<String, dynamic>? _toNullableJsonMap(dynamic data) {
  final map = _toJsonMap(data);
  return map.isEmpty ? null : map;
}

List<dynamic> _toList(dynamic data) {
  if (data is List) {
    return data;
  }
  return const <dynamic>[];
}

String? _stringOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _intOrNull(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}

double? _doubleOrNull(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value == null) {
    return null;
  }
  return double.tryParse(value.toString());
}

num? _numOrNull(Object? value) {
  if (value is num) {
    return value;
  }
  if (value == null) {
    return null;
  }
  return num.tryParse(value.toString());
}

bool? _boolOrNull(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value == null) {
    return null;
  }
  final text = value.toString().toLowerCase();
  if (text == 'true') {
    return true;
  }
  if (text == 'false') {
    return false;
  }
  return null;
}
