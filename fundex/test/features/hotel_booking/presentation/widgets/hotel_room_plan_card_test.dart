import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_booking_presenter.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_room_plan_card.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('zh'));

  testWidgets('minimum stay notice replaces availability and disables add', (
    WidgetTester tester,
  ) async {
    var incrementCount = 0;
    var decrementCount = 0;
    var cardTapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.light(locale: const Locale('zh')),
        home: Scaffold(
          body: HotelRoomPlanCard(
            room: _room(minimumStayNights: 5),
            presenter: HotelBookingPresenter('zh'),
            quantity: 0,
            nights: 3,
            onTap: () => cardTapCount += 1,
            onDecrement: () => decrementCount += 1,
            onIncrement: () => incrementCount += 1,
          ),
        ),
      ),
    );

    expect(find.text('最低入住天数5天'), findsOneWidget);
    expect(find.text('仅剩余：4间'), findsNothing);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.tap(find.byIcon(Icons.remove_rounded));

    expect(incrementCount, 0);
    expect(decrementCount, 0);
    expect(cardTapCount, 0);
  });

  testWidgets('room can be added when selected nights meet minimum stay', (
    WidgetTester tester,
  ) async {
    var incrementCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.light(locale: const Locale('zh')),
        home: Scaffold(
          body: HotelRoomPlanCard(
            room: _room(minimumStayNights: 5),
            presenter: HotelBookingPresenter('zh'),
            quantity: 0,
            nights: 5,
            onDecrement: () {},
            onIncrement: () => incrementCount += 1,
          ),
        ),
      ),
    );

    expect(find.text('最低入住天数5天'), findsNothing);
    expect(find.text('仅剩余：4间'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    expect(incrementCount, 1);
  });
}

HotelRoomPlan _room({required int? minimumStayNights}) {
  return HotelRoomPlan(
    id: 'room-1',
    name: 'Twin room',
    price: 18000,
    beforeDiscountPrice: null,
    discount: null,
    discountName: '',
    occupancy: 2,
    adultCapacity: 2,
    childCapacity: 1,
    baseOccupancy: 2,
    roomSize: '',
    bedroomCount: null,
    bathroomCount: null,
    remainingRooms: 4,
    minimumStayNights: minimumStayNights,
    description: '',
    facilityCategories: const <HotelRoomFacilityCategory>[],
    images: const <HotelDetailImage>[],
    beds: const <HotelRoomBed>[],
  );
}
