import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/shared/services/hive/hives.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const rateLimitDuration = Duration(seconds: 10);

/// A provider that calculates the remaining time until the rate limit resets.
///
/// Returns the remaining time until the rate limit resets as a [Duration] object.
/// If the remaining time is negative, returns null to indicate that the rate limit has already reset.
final remainingRateLimitTimeProvider = Provider<Duration?>((ref) {
  // Get the current rate limit from the rateLimitProvider.
  final DateTime rateLimit = ref.watch(rateLimitProvider);

  // Calculate the remaining time until the rate limit resets.
  final Duration remainingRateLimitTime = rateLimitDuration - DateTime.now().difference(rateLimit);

  // If the remaining time is negative, return null to indicate that the rate limit has already reset.
  if (remainingRateLimitTime.isNegative) {
    return null;
  }

  // Return the remaining time until the rate limit resets.
  return remainingRateLimitTime;
});

/// A [StateNotifierProvider] that provides the current rate limit as a [DateTime] object.
final rateLimitProvider = StateNotifierProvider<RateLimitNotifier, DateTime>((ref) {
  return RateLimitNotifier(ref);
});

class RateLimitNotifier extends StateNotifier<DateTime> {
  final Ref ref;

  static const String rateLimitHiveKey = 'rateLimitHiveKey';

  RateLimitNotifier(this.ref) : super(DateTime.now()) {
    _getRateLimitFromCache();
  }

  /// Retrieves the rate limit from the cache and updates the state if it exists.
  Future<void> _getRateLimitFromCache() async {
    final rateLimit = await HiveService().getItem(key: rateLimitHiveKey, boxType: Hives.customChains);
    if (rateLimit != null) {
      state = rateLimit;
    }
  }

  /// Updates the rate limit in the cache and sets the state to the current time.
  Future<void> setRateLimit({
    DateTime? rateLimit,
  }) async {
    rateLimit ??= DateTime.now();
    await HiveService().putItem(key: rateLimitHiveKey, value: rateLimit, boxType: Hives.customChains);
    state = DateTime.now();
  }
}
