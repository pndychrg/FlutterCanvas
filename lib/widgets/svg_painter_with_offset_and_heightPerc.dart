import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SvgPainterWithOffsetAndHeightPerc extends StatefulWidget {
  SvgPainterWithOffsetAndHeightPerc(
      {super.key,
      required this.boxSize,
      required this.dX,
      required this.dY,
      required this.assetName,
      required this.selectedColor,
      required this.assetHeightRespToBox,
      this.mirror = false});

  final double boxSize, assetHeightRespToBox, dY, dX;
  final String assetName;
  final Color selectedColor;
  bool mirror = false;

  @override
  State<SvgPainterWithOffsetAndHeightPerc> createState() =>
      _SvgPainterWithOffsetAndHeightPercState();
}

class _SvgPainterWithOffsetAndHeightPercState
    extends State<SvgPainterWithOffsetAndHeightPerc> {
  // function was used to fetch svgs from server ( deprecated )
  Future<String?> getStringFromLocalFile() async {
    try {
      final String svgString = await rootBundle.loadString(widget.assetName);
      // print(svgString);
      return svgString;
    } catch (e) {
      print("Error Loading svg file:$e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: widget.mirror ? -1 : 1,
      child: Transform.translate(
        offset: Offset(widget.boxSize * widget.dX, widget.boxSize * widget.dY),
        child: FutureBuilder<String?>(
            future: getStringFromLocalFile(),
            builder: (context, snapshot) {
              return SvgPicture.string(
                snapshot.data?.replaceAll("#FFFFFF",
                        '#${widget.selectedColor.value.toRadixString(16).substring(2)}') ??
                    "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
                height: widget.boxSize / widget.assetHeightRespToBox,
              );
            }),
      ),
    );
  }
}
