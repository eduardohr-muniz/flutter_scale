import 'package:flutter/material.dart';

/// Widget simples que escala o app inteiro mantendo tudo visível na tela
class ScaledApp extends StatefulWidget {
  final Widget child;
  final double scale;

  const ScaledApp({super.key, required this.child, this.scale = 1.0});

  @override
  State<ScaledApp> createState() => _ScaledAppState();
}

class _ScaledAppState extends State<ScaledApp> {
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _currentScale = widget.scale;
  }

  @override
  void didUpdateWidget(ScaledApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scale != widget.scale) {
      setState(() {
        _currentScale = widget.scale;
      });
    }
  }

  /// Método para mudar a escala dinamicamente
  void setScale(double scale) {
    setState(() {
      _currentScale = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / _currentScale,
        height: MediaQuery.of(context).size.height / _currentScale,
        child: MediaQuery(data: MediaQuery.of(context).copyWith(size: Size(MediaQuery.of(context).size.width / _currentScale, MediaQuery.of(context).size.height / _currentScale)), child: widget.child),
      ),
    );
  }
}

/// Widget simples para controlar a escala (opcional)
class ScaleControls extends StatefulWidget {
  final Function(double)? onScaleChanged;
  final double initialScale;

  const ScaleControls({super.key, this.onScaleChanged, this.initialScale = 1.0});

  @override
  State<ScaleControls> createState() => _ScaleControlsState();
}

class _ScaleControlsState extends State<ScaleControls> {
  late double _scale;

  @override
  void initState() {
    super.initState();
    _scale = widget.initialScale;
  }

  void _updateScale(double newScale) {
    setState(() {
      _scale = newScale;
    });
    widget.onScaleChanged?.call(_scale);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Escala: ${_scale.toStringAsFixed(1)}x', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () => _updateScale((_scale - 0.1).clamp(0.1, 5.0)), child: const Text('-')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => _updateScale(1.0), child: const Text('1x')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => _updateScale((_scale + 0.1).clamp(0.1, 5.0)), child: const Text('+')),
          ],
        ),
      ],
    );
  }
}
