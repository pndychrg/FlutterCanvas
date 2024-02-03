import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TShirtCanvas extends StatefulWidget {
  const TShirtCanvas({super.key});

  @override
  State<TShirtCanvas> createState() => _TShirtCanvasState();
}

class _TShirtCanvasState extends State<TShirtCanvas> {
  ValueNotifier<ui.Image?> imageNotifier = ValueNotifier<ui.Image?>(null);

  getImage() {
    AssetImage assetImage = const AssetImage('assets/clipart.png');

    ImageStream imageStream = assetImage.resolve(ImageConfiguration.empty);

    ImageStreamListener imageStreamListener =
        ImageStreamListener((imageInfo, synchronousCall) {
      imageNotifier.value = imageInfo.image;
    });

    imageStream.addListener(imageStreamListener);
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ImagePainterCanvas(imageInfoNotifier: imageNotifier),
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/tshirt.jpg'),
          fit: BoxFit.cover,
          opacity: 0.25,
        )),
      ),
      // size: const Size(3 / 00, 400),
    );
  }
}

class ImagePainterCanvas extends CustomPainter {
  ImagePainterCanvas({required this.imageInfoNotifier})
      : super(repaint: imageInfoNotifier);

  final ValueNotifier<ui.Image?> imageInfoNotifier;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black;

    ui.Image? image = imageInfoNotifier.value;
    if (image != null) {
      Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      Rect imageRect = Offset.zero & imageSize;
      Rect canvasRect = Offset.zero & size;

      canvas.drawImageRect(image, imageRect, canvasRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
