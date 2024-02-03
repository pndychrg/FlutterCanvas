import 'package:flutter/material.dart';
import 'package:human_canvas/human_canvas.dart';
import 'package:human_canvas/tshirt_canvas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          // child: Text('Hello World!'),
          child: Column(
            children: [
              Text("Hello World"),
              // HumanBodyCanvas(),
              TShirtCanvas()
            ],
          ),
        ),
      ),
    );
  }
}
