
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Map>>>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<Map>>> {
  final Ref ref;
  SearchNotifier(this.ref) : super(const AsyncLoading());

  /// Clears the search results by setting the [state] to an empty list.
  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}
