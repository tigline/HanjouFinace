import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../providers/benefit_lottery_status_providers.dart';
import '../support/benefit_lottery_status_content.dart';
import '../widgets/benefit_lottery_status_content_view.dart';

class BenefitLotteryStatusPage extends ConsumerWidget {
  const BenefitLotteryStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final contentAsync = ref.watch(benefitLotteryStatusContentProvider(locale));
    final eligibleAsync = ref.watch(benefitLotteryHasOperatingFundProvider);

    return contentAsync.when(
      loading: () => const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (Object error, StackTrace stackTrace) => Scaffold(
        backgroundColor: Theme.of(context).appColors.background,
        body: SafeArea(
          child: BenefitLotteryStatusLoadError(
            onRetry: () =>
                ref.invalidate(benefitLotteryStatusContentProvider(locale)),
          ),
        ),
      ),
      data: (BenefitLotteryStatusContent content) {
        return BenefitLotteryStatusContentView(
          content: content,
          hasEligibility: eligibleAsync.valueOrNull ?? false,
          isEligibilityLoading: eligibleAsync.isLoading,
          onRefresh: () async {
            ref.invalidate(myPageInvestmentListProvider);
            ref.invalidate(benefitLotteryHasOperatingFundProvider);
            await ref.read(benefitLotteryHasOperatingFundProvider.future);
          },
        );
      },
    );
  }
}
