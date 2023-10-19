import 'package:faucet/shared/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboard extends StatelessWidget {
  const CopyToClipboard({
    super.key,
    required this.rightText,
  });

  final String rightText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: rightText));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.copyToClipboard),
            ),
          );
        },
        child: const Icon(Icons.copy));
  }
}
