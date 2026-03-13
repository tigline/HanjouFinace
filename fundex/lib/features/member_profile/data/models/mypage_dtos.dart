import '../../domain/entities/mypage_models.dart';

class MyPageAccountStatisticDto {
  const MyPageAccountStatisticDto({
    this.userId,
    this.total,
    this.crowdfundingTotal,
    this.financialTotal,
    this.firstLevelAccountTotal,
  });

  factory MyPageAccountStatisticDto.fromJson(Map<String, dynamic> json) {
    return MyPageAccountStatisticDto(
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

  MyPageAccountStatistic toEntity() {
    return MyPageAccountStatistic(
      userId: userId,
      total: total,
      crowdfundingTotal: crowdfundingTotal,
      financialTotal: financialTotal,
      firstLevelAccountTotal: firstLevelAccountTotal,
    );
  }
}

class MyPageInvestorTypeDto {
  const MyPageInvestorTypeDto({
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

  factory MyPageInvestorTypeDto.fromJson(Map<String, dynamic> json) {
    return MyPageInvestorTypeDto(
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

  MyPageInvestorType toEntity() {
    return MyPageInvestorType(
      id: id,
      projectId: projectId,
      investorType: investorType,
      investorCode: investorCode,
      earningsType: earningsType,
      earningsRadio: earningsRadio,
      interestRadio: interestRadio,
      remark: remark,
      isOpen: isOpen,
      isOpenType: isOpenType,
    );
  }
}

class MyPagePdfUrlDto {
  const MyPagePdfUrlDto({this.name, this.url, this.createTime});

  factory MyPagePdfUrlDto.fromJson(Map<String, dynamic> json) {
    return MyPagePdfUrlDto(
      name: _stringOrNull(json['name']),
      url: _stringOrNull(json['url']),
      createTime: _stringOrNull(json['createTime']),
    );
  }

  final String? name;
  final String? url;
  final String? createTime;

  MyPagePdfUrl toEntity() {
    return MyPagePdfUrl(name: name, url: url, createTime: createTime);
  }
}

class MyPagePdfDocumentDto {
  const MyPagePdfDocumentDto({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <MyPagePdfUrlDto>[],
  });

  factory MyPagePdfDocumentDto.fromJson(Map<String, dynamic> json) {
    return MyPagePdfDocumentDto(
      projectId: _stringOrNull(json['projectId']),
      type: _intOrNull(json['type']),
      description: _stringOrNull(json['desc']),
      urls: _toList(json['urls'])
          .map((item) {
            if (item is String) {
              return MyPagePdfUrlDto(url: item);
            }
            return MyPagePdfUrlDto.fromJson(_toJsonMap(item));
          })
          .toList(growable: false),
    );
  }

  final String? projectId;
  final int? type;
  final String? description;
  final List<MyPagePdfUrlDto> urls;

  MyPagePdfDocument toEntity() {
    return MyPagePdfDocument(
      projectId: projectId,
      type: type,
      description: description,
      urls: urls.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}

class MyPageApplyRecordDto {
  const MyPageApplyRecordDto({
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

  factory MyPageApplyRecordDto.fromJson(Map<String, dynamic> json) {
    return MyPageApplyRecordDto(
      projectId:
          _stringOrNull(json['projectId']) ?? _stringOrNull(json['projecId']),
      secondaryMarketSellId: _stringOrNull(json['secondaryMarketSellId']),
      fromProcessId: _stringOrNull(json['fromProcessId']),
      investorCode: _stringOrNull(json['investorCode']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : MyPageInvestorTypeDto.fromJson(_toJsonMap(json['investorType'])),
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
  final MyPageInvestorTypeDto? investorType;
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

  MyPageApplyRecord toEntity() {
    return MyPageApplyRecord(
      projectId: projectId,
      secondaryMarketSellId: secondaryMarketSellId,
      fromProcessId: fromProcessId,
      investorCode: investorCode,
      investorType: investorType?.toEntity(),
      projectName: projectName,
      memberId: memberId,
      accountId: accountId,
      memberName: memberName,
      status: status,
      applyNum: applyNum,
      applyMoney: applyMoney,
      feeRatio: feeRatio,
      sellerFeeRatio: sellerFeeRatio,
      applyTime: applyTime,
      passNum: passNum,
      passMoney: passMoney,
      passTime: passTime,
      actualArrivalTime: actualArrivalTime,
      investNum: investNum,
      investMoney: investMoney,
      processId: processId,
      serviceFee: serviceFee,
    );
  }
}

class MyPageOrderInquiryRecordDto {
  const MyPageOrderInquiryRecordDto({
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
    this.pdfDocuments = const <MyPagePdfDocumentDto>[],
  });

  factory MyPageOrderInquiryRecordDto.fromJson(Map<String, dynamic> json) {
    return MyPageOrderInquiryRecordDto(
      id: _stringOrNull(json['id']),
      memberId: _intOrNull(json['memberId']),
      fromProcessId: _stringOrNull(json['fromProcessId']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : MyPageInvestorTypeDto.fromJson(_toJsonMap(json['investorType'])),
      projectName: _stringOrNull(json['projectName']) ?? '',
      sellNum: _intOrNull(json['sellNum']),
      soldNum: _intOrNull(json['soldNum']),
      price: _numOrNull(json['price']),
      status: _stringOrNull(json['status']),
      createTime: _stringOrNull(json['createTime']),
      updateTime: _stringOrNull(json['updateTime']),
      pdfDocuments: _toList(json['pdfs'])
          .map((item) => MyPagePdfDocumentDto.fromJson(_toJsonMap(item)))
          .toList(growable: false),
    );
  }

  final String? id;
  final int? memberId;
  final String? fromProcessId;
  final MyPageInvestorTypeDto? investorType;
  final String projectName;
  final int? sellNum;
  final int? soldNum;
  final num? price;
  final String? status;
  final String? createTime;
  final String? updateTime;
  final List<MyPagePdfDocumentDto> pdfDocuments;

  MyPageOrderInquiryRecord toEntity() {
    return MyPageOrderInquiryRecord(
      id: id,
      memberId: memberId,
      fromProcessId: fromProcessId,
      investorType: investorType?.toEntity(),
      projectName: projectName,
      sellNum: sellNum,
      soldNum: soldNum,
      price: price,
      status: status,
      createTime: createTime,
      updateTime: updateTime,
      pdfDocuments: pdfDocuments
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

class MyPageInvestmentRecordDto {
  const MyPageInvestmentRecordDto({
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

  factory MyPageInvestmentRecordDto.fromJson(Map<String, dynamic> json) {
    return MyPageInvestmentRecordDto(
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
          : MyPageInvestorTypeDto.fromJson(_toJsonMap(json['investorType'])),
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
  final MyPageInvestorTypeDto? investorType;

  MyPageInvestmentRecord toEntity() {
    return MyPageInvestmentRecord(
      projectId: projectId,
      projectName: projectName,
      processId: processId,
      investNum: investNum,
      investMoney: investMoney,
      investNumValid: investNumValid,
      investMoneyValid: investMoneyValid,
      investNumRemaining: investNumRemaining,
      status: status,
      projectStatus: projectStatus,
      createTime: createTime,
      withdrawalTime: withdrawalTime,
      investorCode: investorCode,
      earningType: earningType,
      earningRadio: earningRadio,
      remark: remark,
      memberId: memberId,
      accountId: accountId,
      memberName: memberName,
      earnings: earnings,
      checkTimes: checkTimes,
      investorType: investorType?.toEntity(),
    );
  }
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
