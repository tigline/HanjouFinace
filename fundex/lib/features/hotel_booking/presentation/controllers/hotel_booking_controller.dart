import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/hotel_models.dart';
import '../../domain/usecases/search_hotels_usecase.dart';

class HotelBookingState {
  const HotelBookingState({
    required this.criteria,
    this.hotels = const <HotelSummary>[],
    this.totalCount = 0,
    this.nextPage = 1,
    this.limit = 9,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
  });

  final HotelSearchCriteria criteria;
  final List<HotelSummary> hotels;
  final int totalCount;
  final int nextPage;
  final int limit;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final Object? error;
  final Object? loadMoreError;

  bool get hasContent => hotels.isNotEmpty;
  bool get hasMore => hotels.length < totalCount;

  HotelBookingState copyWith({
    HotelSearchCriteria? criteria,
    List<HotelSummary>? hotels,
    int? totalCount,
    int? nextPage,
    int? limit,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    Object? error = _unchanged,
    Object? loadMoreError = _unchanged,
  }) {
    return HotelBookingState(
      criteria: criteria ?? this.criteria,
      hotels: hotels ?? this.hotels,
      totalCount: totalCount ?? this.totalCount,
      nextPage: nextPage ?? this.nextPage,
      limit: limit ?? this.limit,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _unchanged) ? this.error : error,
      loadMoreError: identical(loadMoreError, _unchanged)
          ? this.loadMoreError
          : loadMoreError,
    );
  }
}

class HotelBookingController extends StateNotifier<HotelBookingState> {
  HotelBookingController({
    required SearchHotelsUseCase searchHotels,
    required String languageCode,
    DateTime? now,
  }) : _searchHotels = searchHotels,
       _languageCode = languageCode,
       super(
         HotelBookingState(
           criteria: HotelSearchCriteria.initial(now ?? DateTime.now()),
           isLoading: true,
         ),
       ) {
    refresh();
  }

  final SearchHotelsUseCase _searchHotels;
  final String _languageCode;

  Future<void> refresh() async {
    final keepContent = state.hotels.isNotEmpty;
    state = state.copyWith(
      isLoading: !keepContent,
      isRefreshing: keepContent,
      isLoadingMore: false,
      error: null,
      loadMoreError: null,
    );
    try {
      final result = await _searchHotels(
        criteria: state.criteria,
        languageCode: _languageCode,
        page: 1,
        limit: state.limit,
      );
      state = state.copyWith(
        hotels: result.hotels,
        totalCount: result.totalCount,
        nextPage: 2,
        isLoading: false,
        isRefreshing: false,
        error: null,
        loadMoreError: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    }
  }

  Future<void> submitSearch({
    String? keyword,
    String? area,
    DateTime? checkInDate,
    DateTime? checkOutDate,
  }) {
    final nextCheckIn = checkInDate ?? state.criteria.checkInDate;
    var nextCheckOut = checkOutDate ?? state.criteria.checkOutDate;
    if (!nextCheckOut.isAfter(nextCheckIn)) {
      nextCheckOut = nextCheckIn.add(const Duration(days: 1));
    }
    state = state.copyWith(
      criteria: state.criteria.copyWith(
        keyword: keyword,
        area: area,
        checkInDate: nextCheckIn,
        checkOutDate: nextCheckOut,
        stayBenefit: false,
      ),
      totalCount: 0,
      nextPage: 1,
      loadMoreError: null,
    );
    return refresh();
  }

  Future<void> applyCriteria(HotelSearchCriteria criteria) {
    final nextCheckIn = criteria.checkInDate;
    var nextCheckOut = criteria.checkOutDate;
    if (!nextCheckOut.isAfter(nextCheckIn)) {
      nextCheckOut = nextCheckIn.add(const Duration(days: 1));
    }
    state = state.copyWith(
      criteria: criteria.copyWith(
        checkInDate: nextCheckIn,
        checkOutDate: nextCheckOut,
        occupancy: criteria.occupancy.clamp(1, 20),
        kids: criteria.kids.clamp(0, 20),
        roomCount: criteria.roomCount.clamp(1, 10),
        stayBenefit: false,
      ),
      totalCount: 0,
      nextPage: 1,
      loadMoreError: null,
    );
    return refresh();
  }

  Future<void> selectBuildingCode(String? buildingCode) {
    state = state.copyWith(
      criteria: state.criteria.copyWith(
        buildingCode: buildingCode,
        stayBenefit: false,
      ),
      totalCount: 0,
      nextPage: 1,
      loadMoreError: null,
    );
    return refresh();
  }

  Future<void> setPriceSort(HotelPriceSort priceSort) {
    state = state.copyWith(
      criteria: state.criteria.copyWith(
        priceSort: priceSort,
        stayBenefit: false,
      ),
      totalCount: 0,
      nextPage: 1,
      loadMoreError: null,
    );
    return refresh();
  }

  Future<void> setGuestCounts({
    required int adults,
    required int children,
    required int rooms,
  }) {
    state = state.copyWith(
      criteria: state.criteria.copyWith(
        occupancy: adults.clamp(1, 20),
        kids: children.clamp(0, 20),
        roomCount: rooms.clamp(1, 10),
        stayBenefit: false,
      ),
      totalCount: 0,
      nextPage: 1,
      loadMoreError: null,
    );
    return refresh();
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isRefreshing ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }
    final page = state.nextPage;
    state = state.copyWith(isLoadingMore: true, loadMoreError: null);
    try {
      final result = await _searchHotels(
        criteria: state.criteria,
        languageCode: _languageCode,
        page: page,
        limit: state.limit,
      );
      final nextHotels = <HotelSummary>[...state.hotels, ...result.hotels];
      state = state.copyWith(
        hotels: nextHotels,
        totalCount: result.hotels.isEmpty
            ? nextHotels.length
            : result.totalCount,
        nextPage: page + 1,
        isLoadingMore: false,
        loadMoreError: null,
      );
    } catch (error) {
      state = state.copyWith(isLoadingMore: false, loadMoreError: error);
    }
  }
}

const Object _unchanged = Object();
