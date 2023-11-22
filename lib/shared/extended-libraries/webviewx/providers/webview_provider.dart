import 'package:easy_web_view/easy_web_view.dart';
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

  loadContent(WebViewXController<dynamic> controller) async {
    await controller.loadContent(
      'http://localhost:PORT/assets/webpages/index.html',
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
