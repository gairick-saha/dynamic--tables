import 'package:custom_tables/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utility/utility.dart';

class DataCubit extends Cubit<List<TableGroupModel>> {
  DataCubit() : super([]);

  void addNewTableGroup() async {
    final List<TableGroupModel> tableGroupsList = List.from(state);

    Color newTableColor = Utility.generateRandomColor();

    tableGroupsList.add(
      TableGroupModel(
        tableId: tableGroupsList.length + 1,
        tableName: "Group ${tableGroupsList.length + 1}",
        tableColor: newTableColor,
        columns: tableGroupsList.isEmpty
            ? []
            : tableGroupsList.last.columns.map(
                (e) {
                  return TableGroupItemColumn(
                    cellHeight: e.cellHeight,
                    cellWidth: e.cellWidth,
                    child: e.child,
                  );
                },
              ).toList(),
      ),
    );

    emit(tableGroupsList);
  }

  void onReorderTableGroups(int oldIndex, int newIndex) {
    final List<TableGroupModel> tableGroupsList = List.from(state);
    TableGroupModel tableGroup = tableGroupsList.removeAt(oldIndex);
    tableGroupsList.insert(newIndex, tableGroup);
    emit(tableGroupsList);
  }

  void onTableGroupItemDropdownExpansionChanged({
    required bool isExpanded,
    required int itemIndex,
  }) {
    final List<TableGroupModel> tableGroupsList = List.from(state);

    final TableGroupModel selectedTableGroup = tableGroupsList[itemIndex];

    tableGroupsList[itemIndex] = selectedTableGroup.toggleExpanded(
      isExpanded: isExpanded,
    );

    /// Uncomment the following for toggling alreadyExpandedTableGroups
    // final List<TableGroupModel> alreadyExpandedTableGroups = tableGroupsList
    //     .where(
    //       (element) =>
    //           element.expanded &&
    //           element.tableId != tableGroupsList[itemIndex].tableId,
    //     )
    //     .toList();

    // if (tableGroupsList[itemIndex].expanded) {
    //   if (alreadyExpandedTableGroups.isNotEmpty) {
    //     for (var element in alreadyExpandedTableGroups) {
    //       int indexOfModifiedTableGroup = tableGroupsList.indexOf(element);
    //       tableGroupsList[indexOfModifiedTableGroup] =
    //           element.copyWith(expanded: false);
    //     }
    //   }
    // }

    emit(tableGroupsList);
  }

  void addNewColumn(TableGroupModel tableGroup) {
    final List<TableGroupModel> tableGroupsList = List.from(state);

    final List<TableGroupModel> newList = tableGroupsList.map(
      (e) {
        List<TableGroupItemColumn> allColumns = List.from(e.columns);
        allColumns.add(
          TableGroupItemColumn(
            cellHeight: kMinInteractiveDimension,
            cellWidth: 120,
            child: Text("Row: 0 , Col: ${allColumns.length}"),
          ),
        );
        return e.copyWith(
          columns: allColumns,
        );
      },
    ).toList();

    emit(newList);

    /// For Single Table Group Only
    // final List<TableGroupModel> tableGroupsList = List.from(state);
    // int tableGroupItemIndex = tableGroupsList.indexOf(tableGroup);
    // List<TableGroupItemColumn> allColumns = List.from(tableGroup.columns);

    // allColumns.add(
    //   TableGroupItemColumn(
    //     cellHeight: kMinInteractiveDimension,
    //     cellWidth: 120,
    //     child: Text("Row: 0 , Col: ${allColumns.length}"),
    //   ),
    // );

    // tableGroupsList[tableGroupItemIndex] = tableGroup.copyWith(
    //   columns: allColumns,
    // );

    // emit(tableGroupsList);
  }

  void addNewRow(TableGroupModel tableGroup) {
    final List<TableGroupModel> tableGroupsList = List.from(state);
    int tableGroupItemIndex = tableGroupsList.indexOf(tableGroup);
    List<TableGroupItemRow> allRows = List.from(tableGroup.rows);

    allRows.add(
      TableGroupItemRow(),
    );

    tableGroupsList[tableGroupItemIndex] = tableGroup.copyWith(
      rows: allRows,
    );

    emit(tableGroupsList);
  }
}
