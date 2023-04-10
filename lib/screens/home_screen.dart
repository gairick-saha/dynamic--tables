import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:reorderables/reorderables.dart';

import '../cubits/data_cubit.dart';
import '../models/models.dart';
import '../widgets/bidirectional_scroll_view.dart';
import '../widgets/table_group_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LinkedScrollControllerGroup _verticalControllersGroup;
  late ScrollController _leftVerticalScrollController;
  late ScrollController _rightVerticalScrollController;
  late ScrollController _horizontalScrollController;

  final double _leftHeaderSize = 150.0;
  bool _showLeftHeaderElevation = false;

  @override
  void initState() {
    _verticalControllersGroup = LinkedScrollControllerGroup();
    _leftVerticalScrollController = _verticalControllersGroup.addAndGet();
    _rightVerticalScrollController = _verticalControllersGroup.addAndGet();
    _horizontalScrollController = ScrollController();

    _horizontalScrollController.addListener(() {
      setState(
        () {
          if (_horizontalScrollController.offset >= 10 &&
              !_showLeftHeaderElevation) {
            _showLeftHeaderElevation = true;
          } else if (_horizontalScrollController.offset < 10 &&
              _showLeftHeaderElevation) {
            _showLeftHeaderElevation = false;
          }
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, List<TableGroupModel>>(
      builder: (BuildContext context, List<TableGroupModel> state) {
        return Scaffold(
          body: SafeArea(
            child: _buildTablesGrpoupList(context, state),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: context.read<DataCubit>().addNewTableGroup,
            child: const Icon(
              Icons.add,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTablesGrpoupList(
      BuildContext context, List<TableGroupModel> tableGroups) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: _rightVerticalScrollController,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: _horizontalScrollController,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          children: tableGroups
              .map(
                (tableGroup) => _buildTableGroupItem(
                  context,
                  tableGroup: tableGroup,
                  itemIndex: tableGroups.indexOf(tableGroup),
                  isLastItem: tableGroups.last == tableGroup,
                  isLeftHeaderColumn: true,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

Widget _buildTableGroupItem(
  BuildContext context, {
  required TableGroupModel tableGroup,
  required int itemIndex,
  required bool isLastItem,
  bool isLeftHeaderColumn = false,
}) {
  return TableGroupItem(
    key: UniqueKey(),
    padding: EdgeInsets.only(
      top: itemIndex == 0 ? 0 : 7.5,
      bottom: isLastItem
          ? 16.0 + (kFloatingActionButtonMargin + kMinInteractiveDimension)
          : 7.5,
    ),
    tableGroup: tableGroup,
    itemGroupIndex: itemIndex,
    onExpansionChanged: (isExpanded) =>
        context.read<DataCubit>().onTableGroupItemDropdownExpansionChanged(
              isExpanded: isExpanded,
              itemIndex: itemIndex,
            ),
    isLeftHeaderColumn: isLeftHeaderColumn,
  );
}
