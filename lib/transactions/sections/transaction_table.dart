import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:faucet/transactions/models/transaction.dart';
import 'package:faucet/transactions/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:faucet/transactions/sections/transaction_row_item.dart';
import 'package:faucet/transactions/widgets/custom_transaction_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// This is a custom widget that shows the transaction table screen
class TransactionTableScreen extends StatefulHookConsumerWidget {
  const TransactionTableScreen({Key? key}) : super(key: key);
  static const String route = '/transactions';
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
        data: (transactions) => Container(
              color: colorTheme == ThemeMode.light ? const Color(0xFFFEFEFE) : const Color(0xFF282A2C),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: isMobile ? 16.0 : 40.0, right: isMobile ? 0 : 40.0, top: 8.0, bottom: 80.0),
                        height: isTablet ? MediaQuery.of(context).size.height - 435 : null,
                        child: SingleChildScrollView(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              cardColor: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
                            ),
                            child: PaginatedDataTable(
                              showCheckboxColumn: false,
                              headingRowHeight: 80,
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
                              availableRowsPerPage: const [1, 5, 10, 50],
                              onRowsPerPageChanged: (newRowsPerPage) {
                                if (newRowsPerPage != null) {
                                  // setState(() {
                                  //   _rowsPerPage = newRowsPerPage;
                                  // });
                                }
                              },
                              onPageChanged: (int? n) {
                                /// value of n is the number of rows displayed so far
                                setState(() {
                                  if (n != null) {
                                    final source = RowDataSource(
                                        transactions, context, getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C));

                                    /// Update rowsPerPage if the remaining count is less than the default rowsPerPage
                                    if (source.rowCount - n < _rowsPerPage) {
                                      _rowsPerPage = source.rowCount - n;
                                    } else {
                                      _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
        error: (error, stack) => const Text('Oops, something unexpected happened'),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}