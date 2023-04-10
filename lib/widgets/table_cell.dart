part of './table_group_item.dart';

class _TableCell extends StatelessWidget {
  const _TableCell({
    Key? key,
    required this.cellWidth,
    required this.cellHeight,
    required this.child,
    this.shape,
    this.onTap,
  }) : super(key: key);

  final double cellWidth;
  final double cellHeight;
  final Widget child;
  final VoidCallback? onTap;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      shape: shape,
      child: SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
