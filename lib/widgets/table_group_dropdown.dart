part of './table_group_item.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class TableGroupDropdown extends StatefulWidget {
  const TableGroupDropdown({
    Key? key,
    required this.title,
    this.subtitle,
    this.color = Colors.blue,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.radius = BorderRadius.zero,
    this.child,
    required this.columns,
    required this.cellWidth,
    required this.leftCellWidth,
    this.cellHeight = kMinInteractiveDimension,
    required this.isLeftStickyColumn,
    this.onAddNewColumnPressed,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final Color color;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final BorderRadius radius;
  final Widget? child;
  final List<TableGroupItemColumn> columns;
  final double cellWidth;
  final double leftCellWidth;
  final double cellHeight;
  final bool isLeftStickyColumn;
  final VoidCallback? onAddNewColumnPressed;

  @override
  State<TableGroupDropdown> createState() => _TableGroupDropdownState();
}

class _TableGroupDropdownState extends State<TableGroupDropdown>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  late AnimationController _controller;
  late Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TableGroupDropdown oldWidget) {
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
      setState(
        () {
          if (_isExpanded) {
            _controller.forward();
          } else {
            _controller.reverse().then<void>((void value) {
              if (!mounted) return;
              setState(() {});
            });
          }
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleTap() {
    _isExpanded = !_isExpanded;
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
    setState(() {});
  }

  Widget _buildChild(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.move,
      child: Material(
        shape: !_isExpanded
            ? NonUniformBorder(
                leftWidth: widget.isLeftStickyColumn ? 8 : 0,
                rightWidth: 0.4,
                topWidth: 0.4,
                bottomWidth: 0.4,
                color: widget.color,
                borderRadius: widget.radius,
              )
            : null,
        color: Colors.transparent,
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: _handleTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.leftCellWidth,
                height: widget.cellHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RotationTransition(
                        turns: _iconTurns,
                        child: Icon(
                          Icons.expand_more,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize: 16,
                                  color: widget.color,
                                ),
                          ),
                          if (widget.subtitle != null && !_isExpanded)
                            Text(
                              widget.subtitle!,
                              style:
                                  DefaultTextStyle.of(context).style.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.columns.length + 1,
                    (columnIndex) {
                      if (widget.columns.length == columnIndex) {
                        return _TableCell(
                          cellHeight: widget.cellHeight,
                          cellWidth: widget.cellWidth,
                          onTap: widget.onAddNewColumnPressed,
                          child: _isExpanded
                              ? Text(
                                  "+ Add Column",
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                )
                              : const SizedBox.shrink(),
                        );
                      }
                      return _TableCell(
                        cellHeight: widget.columns[columnIndex].cellHeight,
                        cellWidth: widget.columns[columnIndex].cellWidth,
                        child: _isExpanded
                            ? widget.columns[columnIndex].child
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    return _buildChild(context);
  }
}
