part of '../models.dart';

class _TableColumnModel {
  const _TableColumnModel({
    required this.cellWidth,
    required this.cellHeight,
    required this.child,
  });

  final double cellWidth;
  final double cellHeight;
  final Widget child;
}
