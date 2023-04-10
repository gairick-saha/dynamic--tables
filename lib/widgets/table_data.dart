part of './table_group_item.dart';

class _TableData extends StatelessWidget {
  const _TableData({
    Key? key,
    required this.tableGroup,
  }) : super(key: key);

  final TableGroupModel tableGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  tableGroup.rows.length,
                  (rowIndex) => _TableCell(
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
                        "Row : $rowIndex, column : 0",
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  tableGroup.rows.length,
                  (rowIndex) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      tableGroup.columns.length + 1,
                      (columnIndex) => _TableCell(
                        cellWidth: 100,
                        cellHeight: kMinInteractiveDimension,
                        shape: NonUniformBorder.all(
                          width: 0.4,
                          color: tableGroup.tableColor,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Center(
                          child: Text(
                            "Row : ${rowIndex + 1}, column : ${columnIndex + 1}",
                          ),
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
