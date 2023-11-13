import 'package:faucet/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/strings.dart';
import '../providers/app_theme_provider.dart';
import '../utils/theme_color.dart';
import 'custom_shared.dart';

/// Footer Widget
class Footer extends HookConsumerWidget {
  static const footerKey = Key('footerKey');
  const Footer({Key key = footerKey}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveBreakpoints.of(context).equals(DESKTOP);
    final isDesktopAndTab = ResponsiveBreakpoints.of(context).between(TABLET, DESKTOP);

    final colorTheme = ref.watch(appThemeColorProvider);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        if (!isDesktop)
          ResponsiveFooter(
            colorTheme: colorTheme,
            rowIcons: const RowIcons(),
          ),
        if (!isDesktop)
          const SizedBox(
            height: 20,
          ),
        const Divider(
          color: Color(0xFFE7E8E8),
          height: 1,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              if (isDesktopAndTab)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 350,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FooterBottomLinks(text: Strings.footerPrivacyPolicy, url: 'topl.co'),
                          SizedBox(width: 15),
                          FooterBottomLinks(text: Strings.footerTermsOfUse, url: 'topl.co'),
                          SizedBox(width: 15),
                          FooterBottomLinks(text: Strings.footerCookiePolicy, url: 'topl.co'),
                          SizedBox(width: 15),
                          FooterBottomLinks(text: Strings.footerCookiePreferences, url: 'topl.co'),
                        ],
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 160,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FooterBottomLinks(
                          text: Strings.footerRightsReserved,
                          url: 'topl.co',
                        ),
                        const SizedBox(width: 15),
                        SvgPicture.asset(
                          colorTheme == ThemeMode.light ? 'assets/icons/logo.svg' : 'assets/icons/logo_dark.svg',
                          width: 32,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class RowIcons extends StatelessWidget {
  const RowIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const RowIconsFooter(
      svgIcons: [
        {'icon': 'assets/icons/linkedin.svg', 'url': 'https://www.linkedin.com/company/topl/'},
        {'icon': 'assets/icons/github.svg', 'url': 'https://github.com/Topl'},
        {'icon': 'assets/icons/instagram.svg', 'url': 'https://www.instagram.com/topl_protocol/'},
        {'icon': 'assets/icons/medium.svg', 'url': 'https://medium.com/topl-blog'},
        {'icon': 'assets/icons/twitter.svg', 'url': 'https://twitter.com/topl_protocol'}
      ],
    );
  }
}

class FooterBottomLinks extends HookConsumerWidget {
  const FooterBottomLinks({super.key, required this.text, required this.url});

  final String text;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          final linkUrl = Uri.https(url, '/privacy-policy/');
          launchUrl(linkUrl);
        },
        child: Text(
          text,
          style: bodySmall(context),
          textAlign: TextAlign.center,
        ));
  }
}

/// Icon Footer Column
class RowIconsFooter extends HookConsumerWidget {
  const RowIconsFooter({
    super.key,
    required this.svgIcons,
  });

  final List<Map> svgIcons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = ref.watch(appThemeColorProvider);
    final isResponsive = ResponsiveBreakpoints.of(context).between(MOBILE, TABLET);

    return Row(
      children: [
        ...svgIcons
            .map(
              (svgIcon) => Row(
                children: [
                  Container(
                    width: isResponsive ? 32 : 42,
                    height: 40,
                    decoration: BoxDecoration(
                      color: getSelectedColor(colorTheme, 0xFFE2E3E3, 0xFF434648),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        //TODO: P.S line only applicable to web version
                        launchUrl(svgIcon['url']);
                      },
                      icon: SvgPicture.asset(
                        svgIcon['icon'],
                        color: getSelectedColor(colorTheme, 0xFF535757, 0xFFC0C4C4),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: svgIcon == svgIcons.last ? 0 : 12,
                  ),
                ],
              ),
            )
            .toList(),
      ],
    );
  }
}

/// Footer Column Widget
class FooterColumn extends HookConsumerWidget {
  const FooterColumn({
    super.key,
    required this.footerLinks,
    required this.footerTitle,
  });
  final List<String> footerLinks;
  final String footerTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = ref.watch(appThemeColorProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          footerTitle,
          style: const TextStyle(
              color: Color(0xFF858E8E),
              fontSize: 16,
              fontFamily: Strings.rationalDisplayFont,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 16,
        ),
        ...footerLinks
            .map((text) => Column(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: getSelectedColor(colorTheme, 0xFF535757, 0xFFC0C4C4),
                          fontSize: 14,
                          fontFamily: Strings.rationalDisplayFont),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ))
            .toList()
      ],
    );
  }
}
