# 📱 Flutter Scale

A powerful and simple Flutter package for creating responsive applications that automatically adapt to different screen sizes, maintaining consistent proportions across devices.

## ✨ Features

- 🎯 **Auto Scale**: Automatically adapts based on reference resolution
- 🎮 **Manual Control**: Allows manual scale adjustment (0.5x, 1x, 2x, etc.)
- ⚡ **Reactive**: Real-time updates during resizing
- 🔒 **Minimum Scale**: Never goes below 1.0x in automatic mode
- 🚀 **Performance**: Optimized system with update threshold
- 📦 **Simple**: Just 3 lines of code to implement

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_scale: ^any
```

Run:

```bash
flutter pub get
```

## 💡 Basic Usage

### 1. Wrap your MaterialApp

```dart
import 'package:flutter_scale/flutter_scale.dart';

MaterialApp(
  title: 'My App',
  home: MyHomePage(),
  builder: (context, child) => FlutterScale.builder(
    context,
    child,
    type: ScaleType.dimension,                 // Auto scale
    baseDimension: const Size(1366, 768),      // Reference resolution
  ),
)
```

### 2. Access the Controller

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = FlutterScale.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Scale: ${controller.scale.toStringAsFixed(2)}x'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Switch to manual control
            controller.changeToFactor(1.5);
          },
          child: Text('Change Scale'),
        ),
      ),
    );
  }
}
```

## 🎮 Scale Modes

### 📐 Dimension (Automatic)

Ideal for creating consistent experiences across different devices:

```dart
FlutterScale.builder(
  context,
  child,
  type: ScaleType.dimension,
  baseDimension: const Size(1920, 1080),  // Full HD base
);
```

**How it works:**
- **1920×1080 → 1.0x** (base scale)
- **3840×2160 → 2.0x** (4K, doubles the size)
- **960×540 → 1.0x** (never goes below 1.0x)

### 🎛️ Factor (Manual)

For precise scale control:

```dart
FlutterScale.builder(
  context,
  child,
  type: ScaleType.factor,
  initialFactor: 1.2,  // 20% larger
);

// Change programmatically
controller.changeFactor(2.0);  // 200%
```

## 📋 Complete API

### Controller Methods

```dart
final controller = FlutterScale.of(context);

// Getters
controller.scale              // double: current scale
controller.type               // ScaleType: current mode
controller.getCurrentResolution()  // String: "1920×1080"

// Mode switching
controller.changeToFactor(1.5);
controller.changeToDimension(const Size(1366, 768));

// Adjustments
controller.changeFactor(2.0);           // For factor mode
controller.changeBaseDimension(size);   // For dimension mode
```

### Builder Configuration

```dart
FlutterScale.builder(
  context,
  child,
  type: ScaleType.dimension,              // or ScaleType.factor
  initialFactor: 1.0,                     // initial factor (factor mode)
  baseDimension: const Size(1366, 768),   // base resolution (dimension mode)
);
```

## 🎯 Use Cases

### 📱 Mobile App → 📺 TV
```dart
// Mobile base
baseDimension: const Size(375, 812),  // iPhone

// Result:
// iPhone (375×812) → 1.0x
// iPad (768×1024) → 1.0x (smaller than base)
// TV (1920×1080) → 2.4x (much larger)
```

### 💻 Responsive Desktop App
```dart
// Laptop base
baseDimension: const Size(1366, 768),

// Result:
// Laptop (1366×768) → 1.0x
// Full HD (1920×1080) → 1.4x
// 4K (3840×2160) → 2.8x
```

### 🎮 Dynamic UI Control
```dart
// User choice buttons
ElevatedButton(
  onPressed: () => controller.changeToFactor(0.8),  // Compact
  child: Text('Compact Mode'),
),
ElevatedButton(
  onPressed: () => controller.changeToFactor(1.5),  // Large
  child: Text('Large Mode'),
),
```

## 🔧 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_scale/flutter_scale.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scale Demo',
      home: HomePage(),
      builder: (context, child) => FlutterScale.builder(
        context,
        child,
        type: ScaleType.dimension,
        baseDimension: const Size(1366, 768),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = FlutterScale.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Scale: ${controller.scale.toStringAsFixed(2)}x'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resolution: ${controller.getCurrentResolution()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => controller.changeToFactor(0.8),
                  child: Text('Small'),
                ),
                ElevatedButton(
                  onPressed: () => controller.changeToFactor(1.0),
                  child: Text('Normal'),
                ),
                ElevatedButton(
                  onPressed: () => controller.changeToFactor(1.5),
                  child: Text('Large'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎨 Advanced Features

### 🔄 Real-time Reactivity
The package automatically detects screen size changes and updates the scale instantly.

### ⚡ Performance Optimization
Threshold system prevents unnecessary rebuilds - only updates when difference is ≥ 0.05.

### 🔒 Smart Limitation
In `dimension` mode, scale never goes below 1.0x, preventing interfaces from becoming too small.

### 📊 Debug Logs
```dart
// Console output example:
📐 Scale Changed: 1.25x
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the project
2. Create a branch for your feature
3. Commit your changes
4. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Complete Example](https://github.com/eduardohr-muniz/flutter_scale/tree/main/example)
- [Issues](https://github.com/eduardohr-muniz/flutter_scale/issues)

---

**Flutter Scale** - Creating consistent responsive experiences! 🚀
