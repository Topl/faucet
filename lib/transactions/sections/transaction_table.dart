import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/shared/constants/ui.dart';
import 'package:faucet/shared/extended-libraries/paginated_table.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:faucet/transactions/models/transaction.dart';
import 'package:faucet/transactions/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:faucet/transactions/sections/transaction_row_item.dart';
import 'package:faucet/transactions/widgets/custom_transaction_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../main.dart';

/// This is a custom widget that shows the transaction table screen
class TransactionTableScreen extends StatefulHookConsumerWidget {
  static const transactionsTableKey = Key('transactionsTableKey');
  const TransactionTableScreen({key = transactionsTableKey}) : super(key: key);
  static const requestTokensKey = Key("requestTokens");
  static const String route = '/transactions';
  static const Key requestTokenButtonKey = Key('requestTokensButton');
  @override
  _TransactionTableScreenState createState() => _TransactionTableScreenState();
}

class _TransactionTableScreenState extends ConsumerState<TransactionTableScreen> {
  bool viewAll = false;
  var _rowsPerPage = 10; //PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);
    final isBiggerTablet = MediaQuery.of(context).size.width == 1024;
    final isBiggerScreen = MediaQuery.of(context).size.width == 1920;
    final colorTheme = ref.watch(appThemeColorProvider);
    final AsyncValue<List<Transaction>> transactionsInfo = ref.watch(transactionsProvider);
    return transactionsInfo.when(
        data: (transactions) {
          return Container(
              color: colorTheme == ThemeMode.light ? const Color(0xFFFEFEFE) : const Color(0xFF282A2C),
              child: Column(children: [
                Wrap(children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: isMobile ? 16.0 : 40.0, right: isMobile ? 0 : 40.0, top: 8.0, bottom: 80.0),
                      height: isTablet ? MediaQuery.of(context).size.height - 435 : null,
                      child: SingleChildScrollView(
                          key: const Key("transactionTableKey"),
                          child: Theme(
                              data: Theme.of(context).copyWith(
                                cardColor: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
                              ),
                              child: PaginatedTable(
                                  showCheckboxColumn: false,
                                  headingRowHeight: 80,
                                  footerButton: Row(
                                    children: [
                                      const SizedBox(width: 180),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 50.0,
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFF0DC8D4),
                                          ),
                                          child: TextButton(
                                            key: TransactionTableScreen.requestTokensKey,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              showModalSideSheet(
                                                context: context,
                                                ignoreAppBar: true,
                                                width: 640,
                                                barrierColor: Colors.white.withOpacity(barrierOpacity),
                                                barrierDismissible: true,
                                                body: ResponsiveBreakPointsWrapper(
                                                  child: GetTestTokens(
                                                    // Assuming this is the content you want to display
                                                    colorTheme: colorTheme,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                  20.0,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              Strings.requestTokens,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  columnSpacing: isBiggerTablet
                                      ? 55
                                      : isTablet
                                          ? 50
                                          : isBiggerScreen
                                              ? 133
                                              : 150,
                                  arrowHeadColor: getSelectedColor(colorTheme, 0xFF282A2C, 0xFFFEFEFE),
                                  source: RowDataSource(
                                      transactions, context, getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C)),
                                  showFirstLastButtons: true,
                                  rowsPerPage: _rowsPerPage,
                                  dataRowHeight: 80,
                                  availableRowsPerPage: const [1, 5, 10, 70],
                                  onRowsPerPageChanged: (newRowsPerPage) {
                                    if (newRowsPerPage != null) {}
                                  },
                                  onPageChanged: (int? n) {
                                    setState(() {
                                      if (n != null) {
                                        final source = RowDataSource(transactions, context,
                                            getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C));
                                        if (source.rowCount - n < _rowsPerPage) {
                                          _rowsPerPage = source.rowCount - n;
                                        } else {
                                          _rowsPerPage = PaginatedTable.defaultRowsPerPage;
                                        }
                                      } else {
                                        _rowsPerPage = 0;
                                      }
                                    });
                                  },
                                  columns: [
                                    DataColumn(
                                      label: Padding(
                                        padding: EdgeInsets.only(left: isTablet ? 2.0 : 40.0),
                                        child: const SizedBox(
                                          child: TableHeaderText(name: Strings.tableTokens),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                        label: Padding(
                                      padding: EdgeInsets.only(left: isTablet ? 2.0 : 40.0),
                                      child: const TableHeaderText(name: Strings.tableNetwork),
                                    )),
                                    DataColumn(
                                        label: Padding(
                                      padding: EdgeInsets.only(left: isTablet ? 2.0 : 40.0),
                                      child: const TableHeaderText(name: Strings.tableWallet),
                                    )),
                                    DataColumn(
                                        label: Padding(
                                      padding: EdgeInsets.only(left: isTablet ? 2.0 : 40.0),
                                      child: const TableHeaderText(name: Strings.tableDateAndTime),
                                    )),
                                    const DataColumn(
                                        label: Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: TableHeaderText(name: Strings.tableHeaderStatus),
                                    )),
                                  ]))))
                ])
              ]));
        },
        error: (error, stack) => const Text('Oops, something unexpected happened'),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
