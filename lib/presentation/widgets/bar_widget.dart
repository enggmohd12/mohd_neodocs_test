import 'package:flutter/material.dart';
import 'package:mohd_neodocs_test/data/models/range_section_model.dart';

class RangeBar extends StatelessWidget {
  final List<RangeSection> ranges;
  final double value;
  final double height;

  const RangeBar({
    super.key,
    required this.ranges,
    required this.value,
    this.height = 40,
  });

  double get _globalMin =>
      ranges.map((e) => e.start).reduce((a, b) => a < b ? a : b);

  double get _globalMax =>
      ranges.map((e) => e.end).reduce((a, b) => a > b ? a : b);

  @override
  Widget build(BuildContext context) {
    final total = _globalMax - _globalMin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final total = _globalMax - _globalMin;

            final rawRatio = total == 0 ? 0.0 : (value - _globalMin) / total;

            final clampedRatio = rawRatio.clamp(0.0, 1.0);

            final centerX = width * clampedRatio;

            const pointerHalfWidth = 6.0;

            final left = (centerX - pointerHalfWidth).clamp(
              0.0,
              width - 2 * pointerHalfWidth,
            );

            return Stack(
              children: [
                Row(
                  children: ranges.map((r) {
                    final w = (r.end - r.start) / total * width;
                    return Container(width: w, height: height, color: r.color);
                  }).toList(),
                ),
                Positioned(
                  left: left,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      
                      CustomPaint(
                        size: const Size(12, 8),
                        painter: _TrianglePainter(color: Colors.black),
                      ),
                      
                      Expanded(child: Container(width: 4, color: Colors.black)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: ranges
              .map(
                (r) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: r.color,
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${r.label} (${r.start.toInt()}-${r.end.toInt()})',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
