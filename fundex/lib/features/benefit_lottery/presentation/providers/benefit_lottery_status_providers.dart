import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../../member_profile/presentation/support/mypage_section_support.dart';
import '../support/benefit_lottery_status_content.dart';

final benefitLotteryHasOperatingFundProvider = FutureProvider.autoDispose<bool>(
  (ref) async {
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    if (!isAuthenticated) {
      return false;
    }

    final records = await ref.watch(myPageInvestmentListProvider.future);
    return filterInvestmentRecordsByActiveFundFilter(
      records,
      MyPageActiveFundFilter.operating,
    ).isNotEmpty;
  },
);

final benefitLotteryStatusContentProvider = FutureProvider.autoDispose
    .family<BenefitLotteryStatusContent, Locale>((ref, Locale locale) async {
      return loadBenefitLotteryStatusContent(locale.toString());
    });
