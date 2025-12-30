import 'dart:ui';

class RangeSection {
  final double start;
  final double end;
  final String label;
  final Color color;

  RangeSection({
    required this.start,
    required this.end,
    required this.label,
    required this.color,
  });

  factory RangeSection.fromJson(Map<String, dynamic> json) {
    final rangeParts = (json['range'] as String).split('-');
    return RangeSection(
      start: double.parse(rangeParts[0]),
      end: double.parse(rangeParts[1]),
      label: json['meaning'] as String,
      color: _parseColor(json['color'] as String),
    );
  }

  static Color _parseColor(String hex) {
    var v = hex.replaceFirst('#', '');
    if (v.length == 6) {
      v = 'FF$v'; // add alpha
    }
    return Color(int.parse(v, radix: 16));
  }
}
