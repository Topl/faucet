import 'package:faucet/shared/extended-libraries/webviewx/src/controller/interface.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/utils/source_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final webViewProvider = StateNotifierProvider<WebViewNotifier, AsyncValue<WebViewXController<dynamic>>>((ref) {
  return WebViewNotifier();
});

class WebViewNotifier extends StateNotifier<AsyncValue<WebViewXController<dynamic>>> {
  WebViewNotifier() : super(const AsyncLoading());

  setController(WebViewXController<dynamic> controller) {
    state = AsyncData(controller);
  }

  final String RECAPTCHA_URL = const String.fromEnvironment('RECAPTCHA_URL', defaultValue: 'RECAPTCHA_URL');
  final String RECAPTCHA_TOKEN = const String.fromEnvironment('RECAPTCHA_TOKEN', defaultValue: 'RECAPTCHA_TOKEN');

  loadContent(WebViewXController<dynamic> controller) async {
    await controller.loadContent(
      '{$RECAPTCHA_URL}{$RECAPTCHA_TOKEN}',
      SourceType.url,
    );
  }
}

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
