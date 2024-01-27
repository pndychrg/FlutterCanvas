import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class HumanBodyCanvas extends StatefulWidget {
  const HumanBodyCanvas({super.key});

  @override
  State<HumanBodyCanvas> createState() => _HumanBodyCanvasState();
}

class _HumanBodyCanvasState extends State<HumanBodyCanvas> {
  Color leftArmColor = Colors.red;
  Color torsoColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300.0,
          height: 400,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/tshirt.jpg'),
            fit: BoxFit.cover,
          )),
          child: CustomPaint(
            // painter: HumanBodyPainter(),
            painter: ArrowPainter(
                leftArmColor: leftArmColor,
                rightArmColor: Colors.red,
                torsoColor: torsoColor),
          ),
        ),
        // Container for color picker
        Container(
          child: Column(
            children: [
              Text("Left Arm Color"),
              MaterialColorPicker(
                onColorChange: (Color color) {
                  setState(() {
                    leftArmColor = color;
                  });
                },
              ),
              Text("Torso Color"),
              MaterialColorPicker(
                onColorChange: (Color color) {
                  setState(() {
                    torsoColor = color;
                  });
                },
                selectedColor: torsoColor,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Color torsoColor;
  final Color rightArmColor;
  final Color leftArmColor;

  ArrowPainter(
      {required this.leftArmColor,
      required this.rightArmColor,
      required this.torsoColor});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var torsoPaint = Paint()
      ..color = torsoColor
      ..style = PaintingStyle.fill;
    var leftArmPaint = Paint()
      ..color = leftArmColor
      ..style = PaintingStyle.fill;
    var rightArmPaint = Paint()
      ..color = rightArmColor
      ..style = PaintingStyle.fill;
    var torsoPath = Path();
    var leftArmPath = Path();
    var rightArmPath = Path();

    torsoPath.moveTo(26, 73);
    torsoPath.quadraticBezierTo(43, 45, 93, 25);
    // path.addArc(Rect.fromLTRB(93, 25, 198, 90), 0, 1);
    torsoPath.quadraticBezierTo(93, 48, 117, 53);
    torsoPath.quadraticBezierTo(170, 68, 198, 25);
    torsoPath.quadraticBezierTo(243, 43, 270, 73);
    torsoPath.lineTo(250, 103);
    torsoPath.quadraticBezierTo(242, 126, 230, 129);
    torsoPath.lineTo(235, 350);
    torsoPath.lineTo(53, 350);
    torsoPath.lineTo(63, 180);
    torsoPath.quadraticBezierTo(65, 130, 26, 73);

    // drawing the left arm
    leftArmPath.moveTo(26, 73);
    leftArmPath.lineTo(0, 167);
    leftArmPath.quadraticBezierTo(52, 195, 59, 189);
    leftArmPath.quadraticBezierTo(60, 185, 62, 172);
    leftArmPath.quadraticBezierTo(64, 130, 26, 73);

    // drawing the right arm
    rightArmPath.moveTo(270, 73);
    rightArmPath.lineTo(295, 175);
    rightArmPath.lineTo(239, 194);
    rightArmPath.quadraticBezierTo(235, 182, 230, 175);
    rightArmPath.lineTo(230, 129);
    rightArmPath.quadraticBezierTo(242, 126, 250, 103);
    rightArmPath.lineTo(270, 73);

    canvas.drawPath(rightArmPath, rightArmPaint);
    canvas.drawPath(torsoPath, torsoPaint);
    canvas.drawPath(leftArmPath, leftArmPaint);
    // drawing the arm
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class HumanBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    // Drawing a simple Rectanlge on T-Shirt
    RRect rect = RRect.fromRectAndRadius(
        Rect.fromPoints(Offset(68, 23), Offset(200, 400)),
        Radius.circular(20.0));
    canvas.drawRRect(rect, paint);
  }

  // @override
  // void paint(Canvas canvas, Size size) {
  //   PictureRecorder recorder = PictureRecorder();
  //   Canvas backgroundCanvas = Canvas(recorder);

  //   // draw the background Image
  //   backgroundCanvas.drawImage(
  //       AssetImage('assets/tshirt.jpg') as Image, Offset(0, 0), Paint());
  // }

  // @override
  // void paint(Canvas canvas, Size size) {
  //   final Paint paint = Paint()
  //     ..color = Colors.blue
  //     ..strokeWidth = 2.0
  //     ..style = PaintingStyle.fill;

  //   // Draw tshirt
  //   canvas.drawRect(Rect.fromPoints(Offset(50, 50), Offset(150, 200)), paint);

  //   // Draw T-shirt sleeves (optional)
  //   paint.color = Colors.blue;
  //   canvas.drawRect(Rect.fromPoints(Offset(30, 70), Offset(50, 150)), paint);
  //   canvas.drawRect(Rect.fromPoints(Offset(150, 70), Offset(170, 150)), paint);
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
