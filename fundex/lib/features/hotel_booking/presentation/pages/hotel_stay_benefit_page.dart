import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../../domain/entities/hotel_models.dart';
import '../controllers/hotel_booking_controller.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_map_route_args.dart';
import '../widgets/hotel_filter_section.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';
import '../widgets/hotel_summary_card.dart';

class HotelStayBenefitPage extends ConsumerStatefulWidget {
  const HotelStayBenefitPage({super.key});

  @override
  ConsumerState<HotelStayBenefitPage> createState() =>
      _HotelStayBenefitPageState();
}

class _HotelStayBenefitPageState extends ConsumerState<HotelStayBenefitPage> {
  late HotelSearchCriteria _criteria = HotelSearchCriteria.initial(
    DateTime.now(),
  ).copyWith(stayBenefit: true);

  Future<void> _applyCriteria(HotelSearchCriteria criteria) async {
    final nextCheckIn = criteria.checkInDate;
    var nextCheckOut = criteria.checkOutDate;
    if (!nextCheckOut.isAfter(nextCheckIn)) {
      nextCheckOut = nextCheckIn.add(const Duration(days: 1));
    }
    setState(() {
      _criteria = criteria.copyWith(
        checkInDate: nextCheckIn,
        checkOutDate: nextCheckOut,
        occupancy: criteria.occupancy.clamp(1, 20),
        kids: criteria.kids.clamp(0, 20),
        roomCount: criteria.roomCount.clamp(1, 10),
        stayBenefit: true,
      );
    });
  }

  Future<void> _setPriceSort(HotelPriceSort priceSort) {
    if (priceSort == _criteria.priceSort) {
      return Future<void>.value();
    }
    setState(() {
      _criteria = _criteria.copyWith(priceSort: priceSort, stayBenefit: true);
    });
    return Future<void>.value();
  }

  Future<void> _refresh() async {
    await Future.wait(<Future<Object?>>[
      ref.refresh(hotelStayBenefitSearchProvider(_criteria).future),
      ref.refresh(hotelStayBenefitPeriodsProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final result = ref.watch(hotelStayBenefitSearchProvider(_criteria));
    final periods =
        ref.watch(hotelStayBenefitPeriodsProvider).valueOrNull ??
        const <HotelStayBenefitPeriod>[];
    final hotels = result.valueOrNull?.hotels ?? const <HotelSummary>[];
    final filterState = HotelBookingState(criteria: _criteria, hotels: hotels);

    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelStayBenefitsTitle,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              ref.read(appImmersiveHotelStatusBarHintProvider.notifier).state =
                  true;
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go('/hotel-booking');
            },
            backgroundColor: colors.surface.withValues(alpha: 0),
            foregroundColor: colors.textPrimary,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    children: <Widget>[
                      HotelFilterSection(
                        state: filterState,
                        presenter: presenter,
                        onPriceSortSelected: _setPriceSort,
                        onCriteriaApplied: _applyCriteria,
                        stayBenefitPeriods: periods,
                        onMapTap: () => context.push(
                          '/hotel-booking/map',
                          extra: _criteria,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (result.hasError && hotels.isNotEmpty)
                SliverToBoxAdapter(
                  child: HotelInlineErrorNotice(
                    onRetry: _refresh,
                    error: result.error,
                  ),
                ),
              if (result.isLoading && !result.hasValue)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (result.hasError && hotels.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: HotelFullPageError(
                    onRetry: _refresh,
                    error: result.error,
                  ),
                )
              else if (hotels.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: HotelEmptyList(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: hotels.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final hotel = hotels[index];
                      final mapArgs = HotelMapRouteArgs.fromHotel(
                        criteria: _criteria,
                        hotel: hotel,
                      );
                      return HotelSummaryCard(
                        hotel: hotel,
                        presenter: presenter,
                        statusText: hotel.stayBenefitParticipate
                            ? null
                            : context.l10n.hotelStayBenefitUnavailableForDate,
                        statusTone: hotel.stayBenefitParticipate
                            ? HotelSummaryCardStatusTone.normal
                            : HotelSummaryCardStatusTone.muted,
                        onTap: hotel.id.trim().isEmpty
                            ? null
                            : () => context.push(
                                '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                                extra: _criteria,
                              ),
                        onMapTap: mapArgs.hasValidTarget
                            ? () => context.push(
                                '/hotel-booking/map',
                                extra: mapArgs,
                              )
                            : null,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
