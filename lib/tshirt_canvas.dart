import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TShirtCanvas extends StatefulWidget {
  const TShirtCanvas({super.key});

  @override
  State<TShirtCanvas> createState() => _TShirtCanvasState();
}

class _TShirtCanvasState extends State<TShirtCanvas> {
  ValueNotifier<ui.Image?> imageNotifier = ValueNotifier<ui.Image?>(null);

  // picking file from android
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  getImage() async {
    // AssetImage assetImage = const AssetImage('assets/clipart.png');

    // ImageStream imageStream = assetImage.resolve(ImageConfiguration.empty);

    // ImageStreamListener imageStreamListener =
    //     ImageStreamListener((imageInfo, synchronousCall) {
    //   imageNotifier.value = imageInfo.image;
    // });

    // imageStream.addListener(imageStreamListener);

    if (_image != null) {
      final ByteData data = await _image!
          .readAsBytes()
          .then((bytes) => ByteData.sublistView(Uint8List.fromList(bytes)));
      final ui.Codec codec = await ui.instantiateImageCodec(data as Uint8List);
      final ui.Image image = (await codec.getNextFrame()).image;

      imageNotifier.value = image;
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image == null ? const Text("No Image Selected") : Image.file(_image!),
        ElevatedButton(onPressed: _pickImage, child: const Text("Pick Image")),
        CustomPaint(
          painter: ImagePainterCanvas(imageInfoNotifier: imageNotifier),
          child: Container(
            width: 300,
            height: 400,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/tshirt.jpg'),
              fit: BoxFit.cover,
              opacity: 0.25,
            )),
          ),
          // size: const Size(3 / 00, 400),
        ),
      ],
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
      double desiredWidth = 200.0;
      double desiredHeight = 300.0;

      // Calculating the scaling factors
      double scaleX = desiredWidth / image.width.toDouble();
      double scaleY = desiredHeight / image.height.toDouble();

      Size imageSize = const Size(300, 400);

      Rect imageRect = Offset.zero & imageSize;
      Rect canvasRect = Offset.zero & size;

      // canvas.drawImageRect(image, imageRect, canvasRect, paint);
      // canvas.drawImageRect(
      //     image,
      //     Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      //     Rect.fromLTRB(0, 0, desiredWidth, desiredHeight),
      //     paint);

      canvas.drawImage(image, Offset.zero, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
