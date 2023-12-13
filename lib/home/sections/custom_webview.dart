import 'package:faucet/shared/extended-libraries/webviewx/providers/webview_provider.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/utils/source_type.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/view/impl/web.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class CustomWebview extends HookConsumerWidget {
  static const recaptchaWidgetKey = Key('recaptcha-widget');
  const CustomWebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const initialContent = '<div></div>';
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    final webView = ref.watch(webViewProvider);
    final webViewNotifier = ref.watch(webViewProvider.notifier);

    return Stack(
      children: [
        WebViewX(
          key: recaptchaWidgetKey,
          initialContent: initialContent,
          initialSourceType: SourceType.html,
          height: isMobile ? 110 : 220,
          width: isMobile ? 200 : 440,
          onWebViewCreated: (controller) => webViewNotifier.setController(controller),
          dartCallBacks: const {},
        ),
        webView.when(
          data: (data) {
            webViewNotifier.loadContent(data);
            return Container();
          },
          error: (error, st) => const Center(child: Text('Error loading WebView')),
          loading: () => const Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }
}
