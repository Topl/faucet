import 'package:faucet/blocks/models/block.dart';
import 'package:faucet/shared/constants/ui.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:faucet/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vrouter/vrouter.dart';

goToBlockDetails({
  required BuildContext context,
  required Block block,
  required ThemeMode colorTheme,
}) {
  final isDesktop = ResponsiveBreakpoints.of(context).equals(DESKTOP);
  isDesktop
      ? showModalSideSheet(
          context: context,
          ignoreAppBar: false,
          width: 640,
          barrierColor: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF353739).withOpacity(0.64),
          barrierDismissible: true,
          //TODO: Replace once Product has designs
          body: const Text('Drawer to appear on search clicked')) //BlockDetailsDrawer(block: block))
      : context.vRouter.to('/block_details');
}

goToTransactionDetails({
  required BuildContext context,
  required Transaction transaction,
}) {
  final isDesktop = ResponsiveBreakpoints.of(context).equals(DESKTOP);
  if (isDesktop) {
    showModalSideSheet(
      context: context,
      ignoreAppBar: true,
      width: 640,
      barrierColor: Colors.white.withOpacity(barrierOpacity),
      // with blur,
      barrierDismissible: true,
      //TODO: Replace once Product has designs
      body: const Text('Drawer to appear on search clicked'),
    );
  } else {
    //context.vRouter.to(TransactionDetailsPage.transactionDetailsPath(transaction.transactionId));
  }
}

// TODO: Implement this
goToUtxoDetails() {}
