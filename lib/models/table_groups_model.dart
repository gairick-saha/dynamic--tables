part of './models.dart';

class TableGroupModel {
  const TableGroupModel({
    required this.tableId,
    required this.tableName,
    required this.tableColor,
    this.expanded = false,
    this.columns = const [],
    this.rows = const [],
  });

  final int tableId;
  final String tableName;
  final Color tableColor;
  final bool expanded;
  final List<TableGroupItemColumn> columns;
  final List<TableGroupItemRow> rows;

  TableGroupModel copyWith({
    int? tableId,
    String? tableName,
    Color? tableColor,
    bool? expanded,
    List<TableGroupItemColumn>? columns,
    List<TableGroupItemRow>? rows,
  }) {
    return TableGroupModel(
      tableId: tableId ?? this.tableId,
      tableName: tableName ?? this.tableName,
      tableColor: tableColor ?? this.tableColor,
      expanded: expanded ?? this.expanded,
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
    );
  }

  TableGroupModel toggleExpanded({bool? isExpanded}) {
    return copyWith(expanded: isExpanded ?? !expanded);
  }

  @override
  String toString() {
    return "tableId: $tableId, tableName: $tableName, tableColor: ${tableColor.value}, expanded: $expanded, columns: ${columns.map((e) => e.toString()).toList()}, rows: ${rows.map((e) => e.toString()).toList()}";
  }
}
