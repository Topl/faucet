import 'package:faucet/main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../chain/sections/chainname_dropdown.dart';
import '../../search/sections/custom_search_bar.dart';
import '../providers/app_theme_provider.dart';
import '../theme.dart';
import '../utils/theme_color.dart';

/// Header widget that displays the logo, search bar and dropdown.
class Header extends HookConsumerWidget {
  static const Key menuKey = Key('menuKey');
  final String logoAsset;
  final VoidCallback onSearch;
  final ValueChanged<String> onDropdownChanged;

  const Header({
    super.key,
    required this.logoAsset,
    required this.onSearch,
    required this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode colorTheme = ref.watch(appThemeColorProvider);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    final isSmallerThanOrEqualToTablet = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
      decoration: BoxDecoration(
        color: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Faucet', style: headlineMedium(context)),
                      Text('by Topl', style: labelSmall(context)),
                    ]),
              ),
              isMobile
                  ? const SizedBox()
                  : SizedBox(
                      width: 400,
                      child: CustomSearchBar(
                        onSearch: onSearch,
                        colorTheme: colorTheme,
                      ),
                    ),
              isSmallerThanOrEqualToTablet
                  ? SizedBox(
                      child: IconButton(
                        key: menuKey,
                        onPressed: () {
                          showGeneralDialog(
                            context: context,
                            pageBuilder: (context, _, __) => ResponsiveBreakPointsWrapper(
                              child: MobileMenu(
                                onSwitchChange: () {
                                  ref.read(appThemeColorProvider.notifier).toggleTheme();
                                },
                              ),
                            ),
                            barrierDismissible: true,
                            transitionDuration: const Duration(milliseconds: 250),
                            barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                  position: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic).drive(
                                    Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero),
                                  ),
                                  child: MaterialConsumer(
                                    child: child,
                                  ));
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 24.0,
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF4B4B4B),
                              // Set border color here
                              width: 1, // Set border width here
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // toggle between light and dark theme
                              ref.read(appThemeColorProvider.notifier).toggleTheme();
                            },
                            icon: colorTheme == ThemeMode.light
                                ? const Icon(
                                    Icons.light_mode,
                                    color: Color(0xFF858E8E),
                                    size: 20.0,
                                  )
                                : const Icon(
                                    Icons.dark_mode,
                                    color: Color(0xFF858E8E),
                                    size: 20.0,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ChainNameDropDown(
                          colorTheme: colorTheme,
                        )
                      ],
                    ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          isMobile
              ? SizedBox(
                  width: double.infinity,
                  child: CustomSearchBar(
                    onSearch: () {
                      // TODO: implement search
                      print("search");
                    },
                    colorTheme: colorTheme,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

/// MaterialConsumer widget that displays the menu items.
class MaterialConsumer extends HookConsumerWidget {
  const MaterialConsumer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode colorTheme = ref.watch(appThemeColorProvider);

    return Column(
      children: [
        Material(
          color: colorTheme == ThemeMode.light
              ? const Color.fromRGBO(254, 254, 254, 0.96)
              : const Color.fromRGBO(53, 55, 57, 0.96),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: child,
              )
            ],
          ),
        )
      ],
    );
  }
}

/// MobileMenu widget that displays the menu items.
class MobileMenu extends HookConsumerWidget {
  MobileMenu({super.key, required this.onSwitchChange});

  final VoidCallback onSwitchChange;

  final List<String> footerLinks = [
    'Topl Privacy Policy',
    'Terms of Use',
    'Use of Cookies',
    'Cookie Preferences',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode colorTheme = ref.watch(appThemeColorProvider);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      size: 24.0,
                      color: Color(0xFF858E8E),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ChainNameDropDown(
                colorTheme: colorTheme,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: bodyMedium(context),
                  ),
                  ThemeModeSwitch(
                    onPressed: () {
                      // toggle between light and dark theme
                      onSwitchChange();
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xFFC0C4C4),
          thickness: 1,
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...footerLinks
                  .map(
                    (text) => Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        text,
                        style: bodyMedium(context),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        )
      ],
    );
  }
}

/// ThemeModeSwitch widget that displays the switch button.
class ThemeModeSwitch extends StatefulWidget {
  const ThemeModeSwitch({Key? key, required this.onPressed}) : super(key: key);
  final Function onPressed;

  @override
  State<ThemeModeSwitch> createState() => _ThemeModeSwitchState();
}

/// ThemeModeSwitch widget state.
class _ThemeModeSwitchState extends State<ThemeModeSwitch> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: darkMode,
      activeColor: const Color(0xFF7040EC),
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          darkMode = value;
        });
        widget.onPressed();
      },
    );
  }
}
