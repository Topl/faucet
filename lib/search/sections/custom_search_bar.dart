import 'dart:async';
import 'package:faucet/search/providers/search_provider.dart';
import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/shared/theme.dart';
import 'package:faucet/shared/utils/debouncer.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A custom search bar widget that displays a search bar and a list of
class CustomSearchBar extends HookConsumerWidget {
  const CustomSearchBar({
    Key? key,
    required this.onSearch,
    required this.colorTheme,
  }) : super(key: key);

  final VoidCallback onSearch;
  final ThemeMode colorTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerLink = LayerLink();

    /// The controller used to control the search text field.
    final searchController = useTextEditingController();
    final showSuggestions = useState(false);

    OverlayEntry? entry;

    /// The list of filtered suggestions to display.
    final filteredSuggestions = useState<List<String>>([]);

    /// The list of suggestions to display.
    final suggestions = useState<List<String>>([]);

    /// The debouncer used to debounce the search text field.
    final Debouncer searchDebouncer = Debouncer(milliseconds: 200);

    // Updates the suggestions list based on the current search text.
    void onSearchTextChanged() {
      final searchText = searchController.text.trim();
      if (searchText.isNotEmpty) {
        final filter = suggestions.value
            .where((suggestion) => suggestion.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
        showSuggestions.value = true;
        filteredSuggestions.value = filter;
      } else {
        showSuggestions.value = false;
      }
    }

    useEffect(() {
      searchController.addListener(onSearchTextChanged);
      return () {
        searchController.removeListener(onSearchTextChanged);
      };
    }, []);

    final searchProvider = StateNotifierProvider(
      (ref) => SearchNotifier(ref),
    );

    final searchNotifier = ref.read(searchProvider.notifier);

    // Performs a search by calling `searchNotifier.searchById` with the given ID,
    // processes the results, and updates relevant values and lists.
    Future<void> performSearch(String id) async {}

    /// Runs the search debouncer with the given ID and prints the results.
    Future<void> searchByIdAndPrintResults(String id) async {
      searchDebouncer.run(() => performSearch(id));
    }

    void closeOverlay() {
      entry?.remove();
      entry = null;
    }

    return CompositedTransformTarget(
      link: layerLink,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: bodyMedium(context),
              controller: searchController,
              onSubmitted: (query) => onSearch(),
              onChanged: (value) {
                showSuggestions.value = value.isNotEmpty;

                if (value.isNotEmpty) {
                  searchByIdAndPrintResults(value);
                }
              },
              decoration: InputDecoration(
                hintText: Strings.searchHintText,
                hintStyle: bodyMedium(context),
                prefixIcon: Icon(
                  Icons.search,
                  color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF4B4B4B),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF4B4B4B),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: const OutlineInputBorder(),
                focusColor: const Color(0xFF4B4B4B),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFF4B4B4B, 0xFF858E8E),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
