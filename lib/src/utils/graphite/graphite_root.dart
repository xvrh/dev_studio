import 'package:flutter/widgets.dart';
import '../../../core/graphite.dart';
import 'graphite_edges.dart';
import 'graphite_grid.dart';

class GraphiteRoot extends StatefulWidget {
  final Matrix mtx;

  GraphiteRoot({
    required this.mtx,
  });
  @override
  State<GraphiteRoot> createState() => _GraphiteRootState();
}

class _GraphiteRootState extends State<GraphiteRoot> {
  @override
  Widget build(BuildContext context) {
    return GraphiteEdges(
      matrix: widget.mtx,
      child: GraphiteGrid(
        matrix: widget.mtx,
      ),
    );
  }
}
