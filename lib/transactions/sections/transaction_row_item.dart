import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/transactions/widgets/custom_transaction_widgets.dart';
import 'package:flutter/material.dart';
import 'package:faucet/transactions/models/transaction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

/// A widget to display the list of transactions.
class TransactionTableRow extends HookConsumerWidget {
  const TransactionTableRow({Key? key, required this.transactions, this.count = 0}) : super(key: key);
  final int count;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Transaction transaction = transactions[count];
    final isDesktop = ResponsiveBreakpoints.of(context).equals(DESKTOP);
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);
    final isResponsive = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);

    return GestureDetector(
        onTap: () {
          // Add what you want to do on tap
        },
        child: Row(
            mainAxisAlignment: isDesktop ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isTablet
                    ? 130
                    : isMobile
                        ? 170
                        : 450,
                child: TransactionColumnText(
                  isTransactionTable: false,
                  textTop: transaction.transactionId.replaceRange(
                      isTablet
                          ? 7
                          : isDesktop
                              ? 38
                              : 16,
                      transaction.transactionId.length,
                      "..."),
                  textBottom: "49 ${Strings.secAgo}",
                  isSmallFont: true,
                ),
              ),
              if (isMobile)
                const SizedBox(
                  width: 30,
                ),
              SizedBox(
                width: isResponsive
                    ? 100
                    : isDesktop
                        ? 150
                        : 200,
                child: TransactionColumnText(
                  isTransactionTable: false,
                  textTop: '${Strings.height}: ${transaction.block.height}',
                  textBottom: '${Strings.slot}: ${transaction.block.slot}',
                ),
              ),
              if (!isMobile)
                SizedBox(
                  width: isTablet
                      ? 110
                      : isDesktop
                          ? 150
                          : 200,
                  child: TransactionColumnText(
                    isTransactionTable: false,
                    textTop: transaction.transactionType.string,
                    textBottom: "",
                    isBottomTextRequired: false,
                  ),
                ),
              if (!isMobile)
                SizedBox(
                  width: isTablet
                      ? 90
                      : isDesktop
                          ? 150
                          : 200,
                  child: TransactionColumnText(
                      isTransactionTable: false,
                      textTop: '${transaction.quantity} ${Strings.topl}',
                      textBottom: '${transaction.amount} ${Strings.bobs}'),
                ),
              if (!isMobile)
                SizedBox(
                  width: isTablet ? 110 : 150,
                  child: TransactionColumnText(
                    isTransactionTable: false,
                    textTop: '${transaction.transactionFee} ${Strings.feeAcronym}',
                    textBottom: "",
                    isBottomTextRequired: false,
                  ),
                ),
              if (!isMobile)
                SizedBox(
                    width: isTablet ? 85 : 300,
                    child: StatusButton(
                      isTransactionTable: true,
                      status: transaction.status.string,
                      hideArrowIcon: false,
                    )),
            ]));
  }
}

/// Data source class for obtaining row data for PaginatedDataTable.
class RowDataSource extends DataTableSource {
  RowDataSource(this.data, this.context, this.clr);

  BuildContext context;
  List<Transaction> data;
  Color clr;

  @override
  DataRow? getRow(int index) {
    final row = data[index];
    if (index < data.length) {
      return DataRow(color: MaterialStateProperty.all(clr), cells: <DataCell>[
        DataCell(GestureDetector(
          child: TransactionColumnText(
            isTransactionTable: true,
            textTop: '${row.transactionId} ${Strings.feeAcronym}',
            textBottom: "",
          ),
        )),
        const DataCell(TransactionColumnText(
          isTransactionTable: true,
          textTop: 'Valhalla',
          textBottom: '',
          isBottomTextRequired: false,
        )),
        const DataCell(TransactionColumnText(
          isTransactionTable: true,
          textTop: '0x2345...0nM987',
          textBottom: "",
          isBottomTextRequired: false,
        )),
        const DataCell(
            TransactionColumnText(isTransactionTable: true, textTop: '06/29/2023', textBottom: '12:33:51 PM')),
        DataCell(StatusButton(
          isTransactionTable: true,
          status: row.status.string,
          hideArrowIcon: false,
        )),
      ]);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
