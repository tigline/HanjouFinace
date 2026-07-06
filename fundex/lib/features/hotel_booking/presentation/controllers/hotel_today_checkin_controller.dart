import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/hotel_models.dart';
import '../../domain/usecases/fetch_hotel_today_checkins_usecase.dart';

@immutable
class HotelTodayCheckInState {
  const HotelTodayCheckInState({
    this.items = const <HotelTodayCheckIn>[],
    this.isLoading = false,
    this.error,
  });

  final List<HotelTodayCheckIn> items;
  final bool isLoading;
  final Object? error;

  bool get hasContent => items.isNotEmpty;

  HotelTodayCheckInState copyWith({
    List<HotelTodayCheckIn>? items,
    bool? isLoading,
    Object? error = _unchanged,
  }) {
    return HotelTodayCheckInState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unchanged) ? this.error : error,
    );
  }
}

class HotelTodayCheckInController
    extends StateNotifier<HotelTodayCheckInState> {
  HotelTodayCheckInController({
    required FetchHotelTodayCheckInsUseCase fetchTodayCheckIns,
    required String languageCode,
  }) : _fetchTodayCheckIns = fetchTodayCheckIns,
       _languageCode = languageCode,
       super(const HotelTodayCheckInState()) {
    refresh();
  }

  final FetchHotelTodayCheckInsUseCase _fetchTodayCheckIns;
  final String _languageCode;

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _fetchTodayCheckIns(languageCode: _languageCode);
      state = state.copyWith(items: items, isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }
}

const Object _unchanged = Object();
