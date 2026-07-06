import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_today_checkin_detail_widgets.dart';

class HotelTodayCheckInDetailPage extends ConsumerStatefulWidget {
  const HotelTodayCheckInDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<HotelTodayCheckInDetailPage> createState() =>
      _HotelTodayCheckInDetailPageState();
}

class _HotelTodayCheckInDetailPageState
    extends ConsumerState<HotelTodayCheckInDetailPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final detailState = ref.watch(hotelOrderDetailProvider(widget.orderId));

    return Scaffold(
      backgroundColor: colors.surfaceAlt,
      appBar: AppNavigationBar(
        title: context.l10n.hotelTodayCheckInTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/hotel-booking/check-in');
          },
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => HotelFullPageError(
          onRetry: () =>
              ref.invalidate(hotelOrderDetailProvider(widget.orderId)),
        ),
        data: (detail) => HotelTodayCheckInDetailContent(
          detail: detail,
          onCheckIn: () => _runCheckIn(detail.summary.id),
        ),
      ),
    );
  }

  Future<void> _runCheckIn(String orderId) async {
    final trimmedOrderId = orderId.trim();
    if (trimmedOrderId.isEmpty) {
      return;
    }
    final l10n = context.l10n;
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.hotelTodayCheckInDialogTitle,
      message: l10n.hotelTodayCheckInDialogMessage,
      barrierDismissible: false,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: l10n.commonCancel, value: false),
        AppDialogAction<bool>(
          label: l10n.commonConfirm,
          value: true,
          isDefaultAction: true,
        ),
      ],
    );
    if (!mounted || confirmed != true) {
      return;
    }
    try {
      await AppLoadingDialog.run(
        context,
        () => ref.read(checkInHotelOrderCustomerUseCaseProvider)(
          orderId: trimmedOrderId,
        ),
        message: l10n.commonPleaseWait,
      );
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.hotelTodayCheckInSuccess);
      ref.invalidate(hotelOrderDetailProvider(widget.orderId));
      ref.invalidate(hotelTodayCheckInControllerProvider);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.hotelTodayCheckInFailed,
        ),
      );
    }
  }
}
