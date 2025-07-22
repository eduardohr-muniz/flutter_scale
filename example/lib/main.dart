import 'package:flutter/material.dart';
import 'package:flutter_scale/flutter_scale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _currentScale = 1.0;

  void _updateScale(double scale) {
    setState(() {
      _currentScale = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaledApp(scale: _currentScale, child: MaterialApp(title: 'Flutter Scale Demo', theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true), home: MyHomePage(onScaleChanged: _updateScale, currentScale: _currentScale)));
  }
}

class MyHomePage extends StatefulWidget {
  final Function(double) onScaleChanged;
  final double currentScale;

  const MyHomePage({super.key, required this.onScaleChanged, required this.currentScale});

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
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('Flutter Scale Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Card com informações sobre a escala
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sistema de Escala Flutter', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Text('Escala atual: ${widget.currentScale.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('Tamanho da tela: ${MediaQuery.of(context).size.width.toInt()} x ${MediaQuery.of(context).size.height.toInt()}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Controles de escala
            ScaleControls(onScaleChanged: widget.onScaleChanged, initialScale: widget.currentScale),

            const SizedBox(height: 32),

            // Demonstração de widgets
            Text('Demonstração', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 16),

            // Container colorido
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Container\n200x100', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
            ),

            const SizedBox(height: 16),

            // Row com containers coloridos
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildColorBox(Colors.red, 'Vermelho'), _buildColorBox(Colors.green, 'Verde'), _buildColorBox(Colors.orange, 'Laranja')]),

            const SizedBox(height: 24),

            // Contador
            const Text('Contador:', style: TextStyle(fontSize: 18)),
            Text('$_counter', style: const TextStyle(fontSize: 48, color: Colors.deepPurple, fontWeight: FontWeight.bold)),

            const SizedBox(height: 32),

            // Botões de exemplo de escala
            const Text('Escalas de exemplo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(onPressed: () => widget.onScaleChanged(0.5), child: const Text('0.5x')),
                ElevatedButton(onPressed: () => widget.onScaleChanged(0.8), child: const Text('0.8x')),
                ElevatedButton(onPressed: () => widget.onScaleChanged(1.0), child: const Text('1.0x')),
                ElevatedButton(onPressed: () => widget.onScaleChanged(1.5), child: const Text('1.5x')),
                ElevatedButton(onPressed: () => widget.onScaleChanged(2.0), child: const Text('2.0x')),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Incrementar', child: const Icon(Icons.add)),
    );
  }

  Widget _buildColorBox(Color color, String label) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]),
      child: Center(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
    );
  }
}
