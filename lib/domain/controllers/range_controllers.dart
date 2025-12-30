import 'package:flutter/foundation.dart';
import 'package:mohd_neodocs_test/data/models/range_section_model.dart';
import 'package:mohd_neodocs_test/data/repository/range_repository.dart';

enum LoadStatus { initial, loading, loaded, error }

class RangeController extends ChangeNotifier {
  final RangeRepository repository;

  RangeController({required this.repository});

  LoadStatus _status = LoadStatus.initial;
  LoadStatus get status => _status;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<RangeSection> _ranges = [];
  List<RangeSection> get ranges => _ranges;
  double _currentValue = 0.0;
  double get currentValue => _currentValue;

  RangeSection? get currentRange {
    if (_ranges.isEmpty) return null;

    for (final r in _ranges) {
      if (_currentValue >= r.start && _currentValue <= r.end) {
        return r;
      }
    }
    return null;
  }

  String get currentRangeStatus {
    if (_ranges.isEmpty) return 'No ranges loaded';

    final minRange = _ranges.first.start;
    final maxRange = _ranges.last.end;

    if (_currentValue < minRange) {
      return 'Below range (< ${minRange.toInt()})';
    } else if (_currentValue > maxRange) {
      return 'Above range (> ${maxRange.toInt()})';
    }

    final range = currentRange;
    if (range != null) {
      return '${range.label} (${range.start.toInt()}–${range.end.toInt()})';
    }

    return 'Outside defined ranges';
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _ranges = await repository.fetchRanges();
      _status = LoadStatus.loaded;
    } catch (e) {
      _status = LoadStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void updateValue(double value) {
    _currentValue = value;
    notifyListeners();
  }
}
