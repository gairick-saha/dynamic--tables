part of './table_group_item.dart';

class _TableData extends StatelessWidget {
  const _TableData({
    Key? key,
    required this.tableGroup,
  }) : super(key: key);

  final TableGroupModel tableGroup;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                tableGroup.rows.length + 1,
                (rowIndex) {
                  if (rowIndex == tableGroup.rows.length) {
                    return _TableCell(
                      onTap: () =>
                          context.read<DataCubit>().addNewRow(tableGroup),
                      cellWidth: 150,
                      cellHeight: kMinInteractiveDimension,
                      shape: NonUniformBorder(
                        leftWidth: 8,
                        rightWidth: 0.4,
                        topWidth: 0.4,
                        bottomWidth: 0.4,
                        color: tableGroup.tableColor.withOpacity(0.6),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Center(
                        child: Text(
                          "+ New Item",
                          style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                        ),
                      ),
                    );
                  }
                  return _TableCell(
                    cellWidth: 150,
                    cellHeight: kMinInteractiveDimension,
                    shape: NonUniformBorder(
                      leftWidth: 8,
                      rightWidth: 0.4,
                      topWidth: 0.4,
                      bottomWidth: 0.4,
                      color: tableGroup.tableColor,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Center(
                      child: Text(
                        "Item ${rowIndex + 1}",
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                tableGroup.rows.length + 1,
                (rowIndex) {
                  /// "Row : ${rowIndex + 1}, column : ${columnIndex + 1}",
                  if (rowIndex == tableGroup.rows.length) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        tableGroup.columns.length + 1,
                        (columnIndex) => _TableCell(
                          cellWidth: 120,
                          cellHeight: kMinInteractiveDimension,
                          shape: NonUniformBorder.all(
                            width: 0.4,
                            color: tableGroup.tableColor,
                            borderRadius: BorderRadius.zero,
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(4.0),
                          //   child: Center(
                          //     child: Text(
                          //       "Row : ${rowIndex + 1}, column : ${columnIndex + 1}",
                          //       softWrap: true,
                          //     ),
                          //   ),
                          // ),
                          child: const SizedBox.shrink(),
                        ),
                      ),
                    );
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      tableGroup.columns.length + 1,
                      (columnIndex) => _TableCell(
                        cellWidth: 120,
                        cellHeight: kMinInteractiveDimension,
                        shape: NonUniformBorder.all(
                          width: 0.4,
                          color: tableGroup.tableColor,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: columnIndex == tableGroup.columns.length
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Row : ${rowIndex + 1}, column : ${columnIndex + 1}",
                                  softWrap: true,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
