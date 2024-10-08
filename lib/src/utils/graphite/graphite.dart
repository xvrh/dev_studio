import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../../core/graphite.dart';
import 'graphite_cell.dart';
import 'graphite_edges_painter.dart';
import 'graphite_root.dart';

export 'graphite_cell.dart';
export 'graphite_edges_painter.dart';

class DirectGraph extends StatefulWidget {
  const DirectGraph({
    required this.list,
    required this.cellSize,
    required this.cellPadding,
    super.key,
    this.paintBuilder,
    this.builder,
    this.contactEdgesDistance = 5.0,
    this.orientation = MatrixOrientation.horizontal,
    this.tipAngle = math.pi * 0.1,
    this.tipLength = 10.0,
    required this.interactiveBuilder,
    this.pathBuilder,
    this.edgeTooltip,
  });

  final Size cellSize;
  final double cellPadding;
  final List<NodeInput> list;
  final double contactEdgesDistance;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final Widget Function(BuildContext, Widget) interactiveBuilder;
  final EdgeTooltip? Function(String, String)? edgeTooltip;

  // Node
  final NodeCellBuilder? builder;

  // Edge
  final EdgePaintBuilder? paintBuilder;
  final EdgePathBuilder? pathBuilder;

  @override
  State<DirectGraph> createState() => _DirectGraphState();

  static DirectGraph of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<DirectGraph>()!;
}

class _DirectGraphState extends State<DirectGraph> {
  @override
  Widget build(BuildContext context) {
    var graph = Graph(list: widget.list);
    var mtx = graph.traverse();
    if (widget.orientation == MatrixOrientation.vertical) {
      mtx = mtx.rotate();
    }
    return GraphiteRoot(mtx: mtx);
  }
}

class EdgeTooltip {
  final String text;
  final TextStyle style;

  EdgeTooltip(this.text, {required this.style});
}
