import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
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
      loading: () => _BenefitLotteryStatusStateScaffold(
        onBack: () => _handleBack(context),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, StackTrace stackTrace) =>
          _BenefitLotteryStatusStateScaffold(
            onBack: () => _handleBack(context),
            child: BenefitLotteryStatusLoadError(
              onRetry: () =>
                  ref.invalidate(benefitLotteryStatusContentProvider(locale)),
              onBack: () => _handleBack(context),
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

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/home');
  }
}

class _BenefitLotteryStatusStateScaffold extends StatelessWidget {
  const _BenefitLotteryStatusStateScaffold({
    required this.onBack,
    required this.child,
  });

  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: context.l10n.benefitLotteryStatusTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack,
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: SafeArea(top: false, child: child),
    );
  }
}
