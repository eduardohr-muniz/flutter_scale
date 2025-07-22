<<<<<<< HEAD
# flutter_scale
=======
# Flutter Scale

Um package Flutter para controlar a escala do app proporcionalmente em diferentes dispositivos como celular, tablet e TV.

## Características

- ✅ **Escala Automática**: Calcula automaticamente o fator de escala baseado em um tamanho de referência
- ✅ **Escala Manual**: Permite ajustar manualmente o fator de escala em tempo real
- ✅ **Reativo**: Sistema totalmente reativo usando ChangeNotifier
- ✅ **Simples de usar**: Fácil integração com MaterialApp existente
- ✅ **Extensions**: Extensions úteis para aplicar escala rapidamente

## Como usar

### 1. Configuração básica

Envolva seu `MaterialApp` com o `ScaledApp`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_scale/flutter_scale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaledApp(
      // Define o tamanho de referência (exemplo: 1200x920)
      referenceSize: const Size(1200, 920),
      // Escala manual inicial (opcional)
      initialManualScale: 1.0,
      child: MaterialApp(
        title: 'Meu App',
        home: const HomePage(),
      ),
    );
  }
}
```

### 2. Usando a extensão .scaled

A forma mais fácil de aplicar escala aos seus valores:

```dart
Container(
  width: 200.scaled,      // Aplica escala automaticamente
  height: 100.scaled,
  padding: EdgeInsets.all(16.scaled),
  child: Text(
    'Texto escalado',
    style: TextStyle(fontSize: 18.scaled),
  ),
)
```

### 3. Controlando a escala programaticamente

```dart
// Mudar o tamanho de referência
FlutterScale.instance.setReferenceSize(const Size(800, 600));

// Ajustar escala manual
FlutterScale.instance.setManualScaleFactor(1.5);

// Incrementar/decrementar escala
FlutterScale.instance.incrementScale(0.1);
FlutterScale.instance.decrementScale(0.1);

// Resetar escala manual
FlutterScale.instance.resetManualScale();
```

### 4. Widget de controles (opcional)

Para debug ou configurações do usuário:

```dart
// Adicione os controles em qualquer lugar do seu app
const ScaleControls()
```

## Como funciona

O sistema funciona da seguinte forma:

1. **Tamanho de referência**: Você define um tamanho base (ex: 1200x920)
2. **Cálculo automático**: O sistema calcula a proporção da tela atual em relação ao tamanho de referência
3. **Escala final**: `Escala Final = Escala Automática × Escala Manual`

### Exemplo prático:

- Referência: 1200x920 (fator base = 1.0)
- Tela atual: 2400x1840 (fator automático = 2.0)
- Escala manual: 1.0
- **Resultado**: Escala final = 2.0

Isso significa que um widget de 100px será renderizado como 200px na tela maior.

## API Completa

### FlutterScale.instance

```dart
// Propriedades
double get scaleFactor           // Escala final (auto × manual)
double get autoScaleFactor       // Escala calculada automaticamente
double get manualScaleFactor     // Escala manual definida pelo usuário
Size get referenceSize           // Tamanho de referência atual

// Métodos de configuração
void setReferenceSize(Size size)
void setManualScaleFactor(double factor)
void incrementScale([double increment = 0.1])
void decrementScale([double decrement = 0.1])
void resetManualScale()

// Métodos utilitários
double scale(double value)
EdgeInsets scaleEdgeInsets(EdgeInsets insets)
Size scaleSize(Size size)
BorderRadius scaleBorderRadius(BorderRadius radius)
TextStyle scaleTextStyle(TextStyle style)
```

### Extensions

```dart
// Para números
double scaledValue = 16.scaled;

// Para widgets
Widget scaledWidget = myWidget.scaled();
Widget customScaledWidget = myWidget.scaled(1.5); // escala customizada
```

## Casos de uso

### Celular para Tablet
```dart
// Referência de celular
FlutterScale.instance.setReferenceSize(const Size(400, 800));
```

### Tablet para TV
```dart
// Referência de tablet
FlutterScale.instance.setReferenceSize(const Size(1200, 920));
```

### App universal
```dart
// O usuário pode escolher o tamanho base que preferir
// e o app se adapta automaticamente para qualquer tela
```

## Executar o exemplo

```bash
cd example
flutter run
```

O exemplo demonstra:
- Informações da escala em tempo real
- Controles para ajustar escala manualmente
- Widgets escalados automaticamente
- Botões para mudar entre diferentes tamanhos de referência

## Licença

MIT License
>>>>>>> c432a35 (Initialize)
