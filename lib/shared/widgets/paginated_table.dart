import 'dart:math' as math;
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

///
/// This Paginated Table comes from the Material UI PaginateDataTable
/// And has been customized and expanded in order to fit our Design need.
///

class PaginatedTable extends StatefulWidget {
  final Widget? footerButton;

  PaginatedTable({
    super.key,
    this.header,
    this.actions,
    this.footerButton,
    required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    double? dataRowHeight,
    double? dataRowMinHeight,
    double? dataRowMaxHeight,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = false,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.arrowHeadColor,
    required this.source,
    this.checkboxHorizontalMargin,
    this.controller,
    this.primary,
  })  : assert(actions == null || (header != null)),
        assert(columns.isNotEmpty),
        assert(sortColumnIndex == null || (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(dataRowMinHeight == null || dataRowMaxHeight == null || dataRowMaxHeight >= dataRowMinHeight),
        assert(dataRowHeight == null || (dataRowMinHeight == null && dataRowMaxHeight == null),
            'dataRowHeight ($dataRowHeight) must not be set if dataRowMinHeight ($dataRowMinHeight) or dataRowMaxHeight ($dataRowMaxHeight) are set.'),
        dataRowMinHeight = dataRowHeight ?? dataRowMinHeight ?? kMinInteractiveDimension,
        dataRowMaxHeight = dataRowHeight ?? dataRowMaxHeight ?? kMinInteractiveDimension,
        assert(rowsPerPage > 0),
        assert(() {
          if (onRowsPerPageChanged != null) {
            assert(availableRowsPerPage.contains(rowsPerPage));
          }
          return true;
        }()),
        assert(
          !(controller != null && (primary ?? false)),
          'Primary ScrollViews obtain their ScrollController via inheritance from a PrimaryScrollController widget. '
          'You cannot both set primary to true and pass an explicit controller.',
        );

  final Widget? header;
  final List<Widget>? actions;
  final List<DataColumn> columns;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueSetter<bool?>? onSelectAll;
  double? get dataRowHeight => dataRowMinHeight == dataRowMaxHeight ? dataRowMinHeight : null;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final double columnSpacing;
  final bool showCheckboxColumn;
  final bool showFirstLastButtons;
  final int? initialFirstRowIndex;
  final ValueChanged<int>? onPageChanged;
  final int rowsPerPage;
  static const int defaultRowsPerPage = 10;
  final List<int> availableRowsPerPage;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final DataTableSource source;

  final DragStartBehavior dragStartBehavior;
  final double? checkboxHorizontalMargin;
  final Color? arrowHeadColor;
  final ScrollController? controller;
  final bool? primary;

  @override
  PaginatedDataTableState createState() => PaginatedDataTableState();
}

class PaginatedDataTableState extends State<PaginatedTable> {
  late int _firstRowIndex;
  late int _rowCount;
  late bool _rowCountApproximate;
  int _selectedRowCount = 0;
  final Map<int, DataRow?> _rows = <int, DataRow?>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex = PageStorage.maybeOf(context)?.readState(context) as int? ?? widget.initialFirstRowIndex ?? 0;
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(PaginatedTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      _rows.clear();
    });
  }

  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) && (oldFirstRowIndex != _firstRowIndex)) {
      widget.onPageChanged!(_firstRowIndex);
    }
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: widget.columns.map<DataCell>((DataColumn column) => DataCell.empty).toList(),
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells = widget.columns.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(index, () => widget.source.getRow(index));
        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  void _handleFirst() {
    pageTo(0);
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex - widget.rowsPerPage, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex + widget.rowsPerPage);
  }

  void _handleLast() {
    pageTo(((_rowCount - 1) / widget.rowsPerPage).floor() * widget.rowsPerPage);
  }

  bool _isNextPageUnavailable() => !_rowCountApproximate && (_firstRowIndex + widget.rowsPerPage >= _rowCount);

  final GlobalKey _tableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double containerWidth;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      containerWidth = 600.0;
    } else if (screenWidth > 800) {
      containerWidth = 500.0;
    } else {
      containerWidth = 300.0;
    }
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> headerWidgets = <Widget>[];
    if (_selectedRowCount == 0 && widget.header != null) {
      headerWidgets.add(Expanded(child: widget.header!));
    } else if (widget.header != null) {
      headerWidgets.add(Expanded(
        child: Text(localizations.selectedRowCountTitle(_selectedRowCount)),
      ));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(
        widget.actions!.map<Widget>((Widget action) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
            child: action,
          );
        }).toList(),
      );
    }

    // FOOTER
    final TextStyle? footerTextStyle = themeData.textTheme.bodySmall;
    final List<Widget> footerWidgets = <Widget>[];
    if (widget.onRowsPerPageChanged != null) {
      final List<Widget> availableRowsPerPage = widget.availableRowsPerPage
          .where((int value) => value <= _rowCount || value == widget.rowsPerPage)
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value'),
        );
      }).toList();
      footerWidgets.addAll(<Widget>[
        Container(width: 14.0),
        Text(localizations.rowsPerPageTitle),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 64.0),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                value: widget.rowsPerPage,
                onChanged: widget.onRowsPerPageChanged,
                style: footerTextStyle,
              ),
            ),
          ),
        ),
      ]);
    }
    footerWidgets.addAll(<Widget>[
      Container(width: 32.0),
      Text(
        localizations.pageRowsInfoTitle(
          _firstRowIndex + 1,
          _firstRowIndex + widget.rowsPerPage,
          _rowCount,
          _rowCountApproximate,
        ),
      ),
      Container(width: 32.0),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_previous, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.firstPageTooltip,
          onPressed: _firstRowIndex <= 0 ? null : _handleFirst,
        ),
      IconButton(
        icon: Icon(Icons.chevron_left, color: widget.arrowHeadColor),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: _firstRowIndex <= 0 ? null : _handlePrevious,
      ),
      Container(width: 24.0),
      IconButton(
        icon: Icon(Icons.chevron_right, color: widget.arrowHeadColor),
        padding: EdgeInsets.zero,
        tooltip: localizations.nextPageTooltip,
        onPressed: _isNextPageUnavailable() ? null : _handleNext,
      ),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_next, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.lastPageTooltip,
          onPressed: _isNextPageUnavailable() ? null : _handleLast,
        ),
      Container(
        width: containerWidth,
      ),
      if (widget.footerButton != null) widget.footerButton!,
    ]);

    return Card(
      semanticContainer: false,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (headerWidgets.isNotEmpty)
                Semantics(
                  container: true,
                  child: DefaultTextStyle(
                    style: _selectedRowCount > 0
                        ? themeData.textTheme.titleMedium!.copyWith(color: themeData.colorScheme.secondary)
                        : themeData.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400),
                    child: IconTheme.merge(
                      data: const IconThemeData(
                        opacity: 0.54,
                      ),
                      child: Ink(
                        height: 64.0,
                        color: _selectedRowCount > 0 ? themeData.secondaryHeaderColor : null,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 24, end: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: headerWidgets,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                primary: widget.primary,
                controller: widget.controller,
                dragStartBehavior: widget.dragStartBehavior,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.minWidth),
                  child: DataTable(
                    key: _tableKey,
                    columns: widget.columns,
                    sortColumnIndex: widget.sortColumnIndex,
                    sortAscending: widget.sortAscending,
                    onSelectAll: widget.onSelectAll,
                    decoration: const BoxDecoration(),
                    dataRowMinHeight: widget.dataRowMinHeight,
                    dataRowMaxHeight: widget.dataRowMaxHeight,
                    headingRowHeight: widget.headingRowHeight,
                    horizontalMargin: widget.horizontalMargin,
                    checkboxHorizontalMargin: widget.checkboxHorizontalMargin,
                    columnSpacing: widget.columnSpacing,
                    showCheckboxColumn: widget.showCheckboxColumn,
                    showBottomBorder: true,
                    rows: _getRows(_firstRowIndex, widget.rowsPerPage),
                  ),
                ),
              ),
              DefaultTextStyle(
                style: footerTextStyle!,
                child: IconTheme.merge(
                  data: const IconThemeData(
                    opacity: 0.54,
                  ),
                  child: SizedBox(
                    height: 56.0,
                    child: SingleChildScrollView(
                      dragStartBehavior: widget.dragStartBehavior,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        children: footerWidgets,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}