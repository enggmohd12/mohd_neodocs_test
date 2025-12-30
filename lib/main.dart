import 'package:flutter/material.dart';
import 'package:mohd_neodocs_test/core/providers/range_provider.dart';
import 'package:mohd_neodocs_test/domain/controllers/range_controllers.dart';
import 'package:mohd_neodocs_test/data/repository/range_repository.dart';
import 'presentation/widgets/bar_widget.dart';

void main() {
  runApp(const RangeApp());
}

class RangeApp extends StatelessWidget {
  const RangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RangeController(repository: RangeRepository())..load();

    return MaterialApp(
      title: 'Range Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RangeProvider(controller: controller, child: const RangeScreen()),
    );
  }
}

class RangeScreen extends StatelessWidget {
  const RangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RangeProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Range Visualizer'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.status == LoadStatus.loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading ranges...'),
                ],
              ),
            );
          }

          if (controller.status == LoadStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load ranges',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: controller.load,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.ranges.isEmpty) {
            return const Center(child: Text('No ranges available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter numeric value',
                    
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.edit),
                    helperText:
                        'Current value: ${controller.currentValue.toStringAsFixed(1)}',
                  ),
                  onChanged: (text) {
                    final v = double.tryParse(text);
                    if (v != null) {
                      controller.updateValue(v);
                    }
                  },
                ),
                const SizedBox(height: 24),
  
                Builder(
                  builder: (context) {
                    final controller = RangeProvider.of(context);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          
                          if (controller.currentRange != null) ...[
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: controller.currentRange!.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              controller.currentRangeStatus,
                              style: TextStyle(
                                fontWeight: controller.currentRange != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: controller.currentRange != null
                                    ? null
                                    : Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Range Visualization',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        RangeBar(
                          ranges: controller.ranges,
                          value: controller.currentValue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
