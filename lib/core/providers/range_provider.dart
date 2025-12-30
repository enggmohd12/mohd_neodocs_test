import 'package:flutter/material.dart';
import 'package:mohd_neodocs_test/domain/controllers/range_controllers.dart';

class RangeProvider extends InheritedNotifier<RangeController> {
  final RangeController controller;

  const RangeProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(notifier: controller);

  static RangeController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<RangeProvider>();
    assert(provider != null, 'No RangeProvider found in context');
    return provider!.controller;
  }
}