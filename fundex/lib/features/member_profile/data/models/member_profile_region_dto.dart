export 'package:company_api_runtime/company_api_runtime.dart'
    show MemberProfileRegionDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show MemberProfileRegionDto;

import '../../domain/entities/member_profile_region.dart';

extension MemberProfileRegionDtoMapper on MemberProfileRegionDto {
  MemberProfileRegion toEntity() {
    return MemberProfileRegion(
      jpName: jpName,
      parentId: parentId,
      regionId: regionId,
      regionType: regionType,
      roomName: roomName,
    );
  }
}
