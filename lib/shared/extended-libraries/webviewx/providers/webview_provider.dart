import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebViewInitializedState extends StateNotifier<bool> {
  WebViewInitializedState() : super(false);

  Future<void> initializeWebView() async {
    await Future.delayed(const Duration(seconds: 1));
    state = true;
  }
}

final webViewInitializedProvider = StateNotifierProvider<WebViewInitializedState, bool>((ref) {
  final webViewState = WebViewInitializedState();
  webViewState.initializeWebView();
  return webViewState;
});

class TokenNotifier extends StateNotifier<String> {
  TokenNotifier() : super('');

  void setToken(String newToken) {
    state = newToken;
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, String>((ref) => TokenNotifier());
