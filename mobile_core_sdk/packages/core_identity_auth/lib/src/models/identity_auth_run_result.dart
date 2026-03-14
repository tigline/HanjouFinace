import 'package:core_foundation/core_foundation.dart';

import '../real_person/real_person_models.dart';

class IdentityAuthRunResult {
  const IdentityAuthRunResult({
    required this.action,
    required this.reasonCode,
    this.verified = false,
    this.identifyResponse,
    this.errorMessage,
  });

  final IdentityAuthAction action;
  final String reasonCode;
  final bool verified;
  final RealPersonIdentifyResponse? identifyResponse;
  final String? errorMessage;
}
