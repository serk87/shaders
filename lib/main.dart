import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shaders_app/shader_home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShaderHomePage(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  var updateTime = 0.0;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: _initShader(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final shader = snapshot.data!.fragmentShader()
            ..setFloat(0, updateTime)
            ..setFloat(1, 300)
            ..setFloat(2, 300);
          return CustomPaint(painter: _MySweepPainter(shader));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset("shaders/sha.glsl");
  }
}

class _MySweepPainter extends CustomPainter {
  _MySweepPainter(this.shader);

  final Shader shader;

  @override
  void paint(Canvas canvas, Size size) {
    const Rect rect = Rect.largest;
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
