import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

import '../models/models.dart';

part './table_group_dropdown.dart';
part './table_data.dart';
part './table_cell.dart';

class TableGroupItem extends StatelessWidget {
  const TableGroupItem({
    Key? key,
    required this.tableGroup,
    required this.itemGroupIndex,
    this.padding = EdgeInsets.zero,
    this.onExpansionChanged,
    required this.isLeftHeaderColumn,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final TableGroupModel tableGroup;
  final int itemGroupIndex;
  final ValueChanged<bool>? onExpansionChanged;
  final bool isLeftHeaderColumn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableGroupDropdown(
            radius: BorderRadius.circular(8.0),
            color: tableGroup.tableColor,
            title: tableGroup.tableName,
            onExpansionChanged: onExpansionChanged,
            initiallyExpanded: tableGroup.expanded,
            cellWidth: 100,
            leftCellWidth: 150,
            onAddNewColumnPressed: () {
              print("Add new column for ${tableGroup.tableName}");
            },
            columns: tableGroup.columns,
            isLeftStickyColumn: isLeftHeaderColumn,
          ),
          Offstage(
            offstage: !tableGroup.expanded,
            child: _TableData(tableGroup: tableGroup),
          ),
        ],
      ),
    );
  }
}
