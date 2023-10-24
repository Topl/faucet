import 'package:faucet/shared/constants/ui.dart';
import 'package:flutter/material.dart';

enum TestScreenSizes {
  mobile(
    size: Size(mobileBreak - 1, 600),
  ),
  tablet(
    size: Size(tabletBreak - 1, 800),
  ),
  desktop(
    size: Size(tabletBreak + 1, 1000),
  );

  const TestScreenSizes({
    required this.size,
  });

  final Size size;
}

class RequiredTest {
  final TestScreenSizes testScreenSize;

  RequiredTest({
    required this.testScreenSize,
  });
}
