import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls whether the lottery entry is shown on the home tab.
///
/// This defaults to visible until the lottery status API is available. The
/// provider remains the presentation-layer seam for the future API state.
final homeLotteryEntryVisibilityProvider = Provider<bool>((ref) => true);
