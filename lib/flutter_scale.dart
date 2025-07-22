import 'package:flutter/material.dart';

/// Controller para controlar a escala globalmente
class ScaleController extends ChangeNotifier {
  double _scale;

  ScaleController(this._scale);

  double get scale => _scale;

  void changeScale(double newScale) {
    if (_scale != newScale) {
      _scale = newScale;
      notifyListeners();
    }
  }
}

/// InheritedWidget reativo para escala global
class FlutterScale extends InheritedNotifier<ScaleController> {
  const FlutterScale._({required ScaleController controller, required super.child}) : super(notifier: controller);

  /// Acessa o controller de escala
  static ScaleController of(BuildContext context) {
    final FlutterScale? inherited = context.dependOnInheritedWidgetOfExactType<FlutterScale>();
    assert(inherited != null, 'FlutterScale não encontrado. Use FlutterScale.builder no MaterialApp');
    return inherited!.notifier!;
  }

  /// Builder para aplicar a escala no widget - gerencia tudo internamente
  static Widget builder(BuildContext context, Widget? child, {double initialScale = 1.0}) {
    return _FlutterScaleRoot(initialScale: initialScale, child: child ?? const SizedBox.shrink());
  }

  @override
  bool updateShouldNotify(FlutterScale oldWidget) => notifier != oldWidget.notifier;
}

/// Widget interno que gerencia o controller e aplica a escala
class _FlutterScaleRoot extends StatefulWidget {
  final double initialScale;
  final Widget child;

  const _FlutterScaleRoot({required this.initialScale, required this.child});

  @override
  State<_FlutterScaleRoot> createState() => _FlutterScaleRootState();
}

class _FlutterScaleRootState extends State<_FlutterScaleRoot> {
  late ScaleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScaleController(widget.initialScale);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterScale._(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final scale = _controller.scale;
          return FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / scale,
              height: MediaQuery.of(context).size.height / scale,
              child: MediaQuery(data: MediaQuery.of(context).copyWith(size: Size(MediaQuery.of(context).size.width / scale, MediaQuery.of(context).size.height / scale)), child: widget.child),
            ),
          );
        },
      ),
    );
  }
}

/// Widget para controlar a escala (opcional)
class ScaleControls extends StatelessWidget {
  final double min;
  final double max;
  final double step;

  const ScaleControls({super.key, this.min = 0.1, this.max = 5.0, this.step = 0.1});

  @override
  Widget build(BuildContext context) {
    final controller = FlutterScale.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Escala: ${controller.scale.toStringAsFixed(1)}x', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(onPressed: () => controller.changeScale((controller.scale - step).clamp(min, max)), child: const Text('-')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => controller.changeScale(1.0), child: const Text('1x')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => controller.changeScale((controller.scale + step).clamp(min, max)), child: const Text('+')),
              ],
            ),
          ],
        );
      },
    );
  }
}
