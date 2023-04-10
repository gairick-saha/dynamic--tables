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

    final List<TableGroupModel> alreadyExpandedTableGroups = tableGroupsList
        .where(
          (element) =>
              element.expanded &&
              element.tableId != tableGroupsList[itemIndex].tableId,
        )
        .toList();

    if (tableGroupsList[itemIndex].expanded) {
      if (alreadyExpandedTableGroups.isNotEmpty) {
        for (var element in alreadyExpandedTableGroups) {
          int indexOfModifiedTableGroup = tableGroupsList.indexOf(element);
          tableGroupsList[indexOfModifiedTableGroup] =
              element.copyWith(expanded: false);
        }
      }
    }

    emit(tableGroupsList);
  }
}
