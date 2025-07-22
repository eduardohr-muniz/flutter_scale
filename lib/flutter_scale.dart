import 'dart:developer';

import 'package:flutter/material.dart';

/// Tipo de escala
enum ScaleType {
  /// Fator manual (usuário controla: 0.5x, 1x, 2x)
  factor,

  /// Baseado em dimensão (sistema calcula automaticamente baseado na resolução base)
  dimension,
}

/// Controller para controlar a escala globalmente
class ScaleController extends ChangeNotifier {
  ScaleType _type;
  double _factor;
  Size? _baseDimension;
  Size? _currentScreenSize;
  double? _lastNotifiedScale; // ✅ NOVO: Armazena a última escala notificada

  ScaleController({required ScaleType type, double factor = 1.0, Size? baseDimension})
      : _type = type,
        _factor = factor,
        _baseDimension = baseDimension;

  ScaleType get type => _type;
  double get factor => _factor;
  Size? get baseDimension => _baseDimension;
  Size? get currentScreenSize => _currentScreenSize;

  /// Escala calculada (automática para dimension, manual para factor)
  double get scale {
    if (_type == ScaleType.factor) {
      return _factor;
    } else {
      // ScaleType.dimension - calcula baseado na tela atual vs base
      if (_currentScreenSize == null || _baseDimension == null) {
        return 1.0;
      }

      final scaleX = _currentScreenSize!.width / _baseDimension!.width;
      final scaleY = _currentScreenSize!.height / _baseDimension!.height;

      // Usa a menor escala para garantir que tudo caiba
      final calculatedScale = (scaleX < scaleY) ? scaleX : scaleY;

      // 🔒 IMPORTANTE: No modo dimension, nunca pode ser menor que 1.0
      final finalScale = calculatedScale < 1.0 ? 1.0 : calculatedScale;

      return finalScale;
    }
  }

  @override
  void notifyListeners() {
    log('📐 Scale Changed: ${scale.toStringAsFixed(2)}x', name: 'FLUTTER_SCALE');
    super.notifyListeners();
  }

  /// Atualiza o tamanho da tela atual (reativo)
  void updateScreenSize(Size newSize) {
    if (_currentScreenSize != newSize) {
      _currentScreenSize = newSize;

      // ✅ Log da dimensão apenas quando mudar
      // log('📱 Screen Size: ${newSize.width.toInt()}×${newSize.height.toInt()}', name: 'FLUTTER_SCALE');

      if (_type == ScaleType.dimension) {
        // ✅ NOVO: Verifica threshold antes de notificar
        if (_shouldNotifyScaleChange()) {
          _lastNotifiedScale = scale; // Atualiza a última escala notificada
          notifyListeners();
        }
      }
    }
  }

  /// ✅ NOVO: Verifica se deve notificar baseado no threshold
  bool _shouldNotifyScaleChange() {
    if (_lastNotifiedScale == null) return true; // Primeira vez sempre notifica

    final currentScale = scale;
    final difference = (currentScale - _lastNotifiedScale!).abs();

    return difference >= 0.05; // Threshold de 0.05
  }

  /// Muda para modo factor e define o fator
  void changeToFactor(double newFactor) {
    _type = ScaleType.factor;
    _factor = newFactor;
    _lastNotifiedScale = null; // ✅ Reset para forçar notificação
    notifyListeners();
  }

  /// Muda para modo dimension e define a resolução base
  void changeToDimension(Size baseDimension) {
    _type = ScaleType.dimension;
    _baseDimension = baseDimension;
    _lastNotifiedScale = null; // ✅ Reset para forçar notificação
    // Recalcula imediatamente se já temos o tamanho da tela
    notifyListeners();
  }

  /// Altera apenas o fator (para modo factor)
  void changeFactor(double newFactor) {
    if (_type == ScaleType.factor) {
      _factor = newFactor;
      _lastNotifiedScale = null; // ✅ Reset para forçar notificação
      notifyListeners();
    }
  }

  /// Altera apenas a dimensão base (para modo dimension)
  void changeBaseDimension(Size newBaseDimension) {
    if (_type == ScaleType.dimension) {
      _baseDimension = newBaseDimension;
      _lastNotifiedScale = null; // ✅ Reset para forçar notificação
      notifyListeners();
    }
  }

  /// ✅ NOVO: Retorna a resolução atual como string formatada
  String getCurrentResolution() {
    if (_currentScreenSize == null) return 'N/A';
    return '${_currentScreenSize!.width.toInt()}×${_currentScreenSize!.height.toInt()}';
  }
}

/// InheritedWidget reativo para escala global
class AutoScaleFlutter extends InheritedNotifier<ScaleController> {
  const AutoScaleFlutter._({required ScaleController controller, required super.child}) : super(notifier: controller);

  /// Acessa o controller de escala
  static ScaleController of(BuildContext context) {
    final AutoScaleFlutter? inherited = context.dependOnInheritedWidgetOfExactType<AutoScaleFlutter>();
    assert(inherited != null, 'AutoScaleFlutter não encontrado. Use AutoScaleFlutter.builder no MaterialApp');
    return inherited!.notifier!;
  }

  /// Builder para aplicar a escala no widget - gerencia tudo internamente
  static Widget builder(BuildContext context, Widget? child, {ScaleType type = ScaleType.factor, double initialFactor = 1.0, Size? baseDimension}) {
    return _AutoScaleFlutterRoot(type: type, initialFactor: initialFactor, baseDimension: baseDimension, child: child ?? const SizedBox.shrink());
  }

  @override
  bool updateShouldNotify(AutoScaleFlutter oldWidget) => notifier != oldWidget.notifier;
}

/// Widget interno que gerencia o controller e aplica a escala
class _AutoScaleFlutterRoot extends StatefulWidget {
  final ScaleType type;
  final double initialFactor;
  final Size? baseDimension;
  final Widget child;

  const _AutoScaleFlutterRoot({required this.type, required this.initialFactor, this.baseDimension, required this.child});

  @override
  State<_AutoScaleFlutterRoot> createState() => _AutoScaleFlutterRootState();
}

class _AutoScaleFlutterRootState extends State<_AutoScaleFlutterRoot> {
  late ScaleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScaleController(type: widget.type, factor: widget.initialFactor, baseDimension: widget.baseDimension);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Monitora mudanças no MediaQuery de forma reativa
    final screenSize = MediaQuery.sizeOf(context);

    // Atualiza o tamanho da tela no controller imediatamente (reativo)
    _controller.updateScreenSize(screenSize);

    return AutoScaleFlutter._(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final scale = _controller.scale;

          return FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(width: screenSize.width / scale, height: screenSize.height / scale, child: MediaQuery(data: MediaQuery.of(context).copyWith(size: Size(screenSize.width / scale, screenSize.height / scale)), child: widget.child)),
          );
        },
      ),
    );
  }
}
