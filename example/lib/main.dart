// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_scale/flutter_scale.dart';

void main() {
  runApp(const MyApp());
}

/// Widget de animação de pulse para botões clicáveis
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    super.key,
    required this.child,
  })  : duration = const Duration(milliseconds: 750),
        minScale = 0.93,
        maxScale = 1.0;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scale Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      builder: (context, child) => FlutterScale.builder(
        context,
        child,
        type: ScaleType.dimension,
        initialFactor: 1.0,
        baseDimension: const Size(1366, 768),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = FlutterScale.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.aspect_ratio, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Flutter Scale Demo', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(theme, controller),

            const SizedBox(height: 24),

            // Scale Controls
            _buildScaleControlsSection(theme),

            const SizedBox(height: 24),

            // Visual Demo
            _buildVisualDemoSection(theme),

            const SizedBox(height: 24),

            // Counter Section
            _buildCounterSection(theme),

            const SizedBox(height: 24),

            // Mode Examples
            _buildModeExamplesSection(theme, controller),
          ],
        ),
      ),
      floatingActionButton: PulseAnimation(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple.shade700],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _incrementCounter,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, ScaleController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade400,
            Colors.deepPurple.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.smartphone, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Flutter Scale',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sistema de Escala Responsiva',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusItem('Modo', controller.type.name.toUpperCase(), Icons.settings),
                    _buildStatusItem('Escala', '${controller.scale.toStringAsFixed(2)}x', Icons.zoom_in),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusItem('Resolução', controller.getCurrentResolution(), Icons.monitor),
                    if (controller.type == ScaleType.dimension && controller.baseDimension != null) _buildStatusItem('Base', '${controller.baseDimension!.width.toInt()}×${controller.baseDimension!.height.toInt()}', Icons.grid_view),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleControlsSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.tune, color: Colors.blue.shade600, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Controles de Escala',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomScaleControls(),
        ],
      ),
    );
  }

  Widget _buildVisualDemoSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.palette, color: Colors.green.shade600, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Demonstração Visual',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Container principal
          Center(
            child: Container(
              width: 240,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Container\n240×120',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Row de cores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorBox(Colors.red, 'Vermelho', Icons.favorite),
              _buildColorBox(Colors.green, 'Verde', Icons.eco),
              _buildColorBox(Colors.orange, 'Laranja', Icons.wb_sunny),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(Color color, String label, IconData icon) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.indigo.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.add_circle, color: Colors.indigo.shade600, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Contador Interativo',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '$_counter',
              style: TextStyle(
                fontSize: 48,
                color: Colors.indigo.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque no + para incrementar',
            style: TextStyle(
              color: Colors.indigo.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeExamplesSection(ThemeData theme, ScaleController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.apps, color: Colors.purple.shade600, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Exemplos de Uso',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Modo Factor
          _buildModeSection(
            'Factor - Controle Manual',
            'Defina escalas fixas manualmente',
            Icons.tune,
            Colors.orange,
            [
              PulseAnimation(
                child: _buildModeButton('0.5x', () => controller.changeToFactor(0.5), Colors.orange),
              ),
              PulseAnimation(
                child: _buildModeButton('1.0x', () => controller.changeToFactor(1.0), Colors.orange),
              ),
              PulseAnimation(
                child: _buildModeButton('1.5x', () => controller.changeToFactor(1.5), Colors.orange),
              ),
              PulseAnimation(
                child: _buildModeButton('2.0x', () => controller.changeToFactor(2.0), Colors.orange),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Modo Dimension
          _buildModeSection(
            'Dimension - Automático',
            'Escala baseada na resolução de referência',
            Icons.auto_awesome,
            Colors.teal,
            [
              PulseAnimation(
                child: _buildModeButton('Laptop\n1366×768', () => controller.changeToDimension(const Size(1366, 768)), Colors.teal),
              ),
              PulseAnimation(
                child: _buildModeButton('Full HD\n1920×1080', () => controller.changeToDimension(const Size(1920, 1080)), Colors.teal),
              ),
              PulseAnimation(
                child: _buildModeButton('2K\n2560×1440', () => controller.changeToDimension(const Size(2560, 1440)), Colors.teal),
              ),
              PulseAnimation(
                child: _buildModeButton('4K\n3840×2160', () => controller.changeToDimension(const Size(3840, 2160)), Colors.teal),
              ),
              PulseAnimation(
                child: _buildModeButton('Mobile\n300x800', () => controller.changeToDimension(const Size(300, 800)), Colors.teal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeSection(String title, String subtitle, IconData icon, Color color, List<Widget> buttons) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: buttons,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget customizado para controles de escala - Versão melhorada para o exemplo
class CustomScaleControls extends StatelessWidget {
  final double min;
  final double max;
  final double step;

  const CustomScaleControls({
    super.key,
    this.min = 0.1,
    this.max = 5.0,
    this.step = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FlutterScale.of(context);
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          children: [
            // Status Cards
            _buildStatusCards(theme, controller, screenSize),

            const SizedBox(height: 20),

            // Controls Based on Mode
            if (controller.type == ScaleType.factor) _buildFactorControls(theme, controller) else _buildDimensionInfo(theme, controller, screenSize),

            const SizedBox(height: 16),

            // Mode Switch Buttons
            _buildModeSwitchButtons(theme, controller),
          ],
        );
      },
    );
  }

  Widget _buildStatusCards(ThemeData theme, ScaleController controller, Size screenSize) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Modo Atual',
            controller.type.name.toUpperCase(),
            controller.type == ScaleType.factor ? Icons.tune : Icons.auto_awesome,
            controller.type == ScaleType.factor ? Colors.orange : Colors.teal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            'Escala',
            '${controller.scale.toStringAsFixed(2)}x',
            Icons.zoom_in,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorControls(ThemeData theme, ScaleController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Controle Manual',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PulseAnimation(
                child: _buildControlButton(
                  '-',
                  Icons.remove,
                  Colors.red,
                  () => controller.changeFactor(
                    (controller.factor - step).clamp(min, max),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  '${controller.factor.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
              ),
              PulseAnimation(
                child: _buildControlButton(
                  '+',
                  Icons.add,
                  Colors.green,
                  () => controller.changeFactor(
                    (controller.factor + step).clamp(min, max),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PulseAnimation(
            child: ElevatedButton.icon(
              onPressed: () => controller.changeFactor(1.0),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Resetar (1.0x)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade100,
                foregroundColor: Colors.orange.shade700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 0,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildDimensionInfo(ThemeData theme, ScaleController controller, Size screenSize) {
    final scaleX = controller.baseDimension != null ? screenSize.width / controller.baseDimension!.width : 1.0;
    final scaleY = controller.baseDimension != null ? screenSize.height / controller.baseDimension!.height : 1.0;
    final calculatedScale = scaleX < scaleY ? scaleX : scaleY;
    final isLimited = calculatedScale < 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.teal, size: 20),
              const SizedBox(width: 8),
              Text(
                'Modo Automático',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (controller.baseDimension != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDimensionDisplay('Base', controller.baseDimension!, Colors.teal.shade600),
                Icon(Icons.arrow_forward, color: Colors.teal.shade400),
                _buildDimensionDisplay('Atual', screenSize, Colors.teal.shade700),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLimited ? Colors.orange.withOpacity(0.1) : Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isLimited ? Colors.orange.withOpacity(0.3) : Colors.teal.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isLimited ? Icons.lock : Icons.check_circle,
                    color: isLimited ? Colors.orange : Colors.teal,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isLimited ? 'Limitado a 1.0x (tela menor que base)' : 'Responsivo: Escala ${controller.scale.toStringAsFixed(2)}x',
                      style: TextStyle(
                        color: isLimited ? Colors.orange.shade700 : Colors.teal.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDimensionDisplay(String label, Size size, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${size.width.toInt()}×${size.height.toInt()}',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSwitchButtons(ThemeData theme, ScaleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mudar Modo:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PulseAnimation(
                child: _buildModeButton(
                  'Factor',
                  'Controle Manual',
                  Icons.tune,
                  Colors.orange,
                  controller.type == ScaleType.factor,
                  () => controller.changeToFactor(1.0),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PulseAnimation(
                child: _buildModeButton(
                  'Dimension',
                  'Automático',
                  Icons.auto_awesome,
                  Colors.teal,
                  controller.type == ScaleType.dimension,
                  () => controller.changeToDimension(const Size(1366, 768)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? color : Colors.grey.shade100,
        foregroundColor: isActive ? Colors.white : Colors.grey.shade700,
        elevation: isActive ? 2 : 0,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isActive ? color : Colors.grey.shade300,
            width: isActive ? 0 : 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
