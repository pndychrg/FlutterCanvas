import 'package:flutter/material.dart';
import 'package:human_canvas/widgets/svg_painter_with_offset_and_heightPerc.dart';
import '../models/asset_info_model.dart';

class CustomTshirtWithSvgPaint extends StatelessWidget {
  const CustomTshirtWithSvgPaint(
      {super.key,
      required this.selectedCollor,
      required this.selectedSleeve,
      required this.collorColor,
      required this.torsoColor,
      required this.sleeveColor});

  final AssetInfoModel selectedCollor;
  final AssetInfoModel selectedSleeve;
  final Color collorColor;
  final Color torsoColor;
  final Color sleeveColor;
  // final AssetInfoModel selectedCollorItem;

  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width / 2; // default is 400
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: Container(
            height: boxSize,
            width: boxSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10.2)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(
                      0.2), // Grey shadow color with subtle opacity
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                SvgPainterWithOffsetAndHeightPerc(
                  assetName: "assets/shirt_outline.svg",
                  boxSize: boxSize,
                  dX: .25,
                  dY: .1,
                  selectedColor: torsoColor,
                  assetHeightRespToBox: 1.5,
                ),
                SvgPainterWithOffsetAndHeightPerc(
                  assetName: selectedSleeve.assetLocation,
                  boxSize: boxSize,
                  dX: selectedSleeve.dX,
                  dY: selectedSleeve.dY,
                  selectedColor: sleeveColor,
                  assetHeightRespToBox: selectedSleeve.assetHeightRespToBox,
                ),
                SvgPainterWithOffsetAndHeightPerc(
                  assetName: selectedSleeve.assetLocation,
                  boxSize: boxSize,
                  dX: selectedSleeve.mirrorDX!,
                  dY: selectedSleeve.dY,
                  selectedColor: sleeveColor,
                  assetHeightRespToBox: selectedSleeve.assetHeightRespToBox,
                  mirror: true,
                ),
                SvgPainterWithOffsetAndHeightPerc(
                  assetName: selectedCollor.assetLocation,
                  boxSize: boxSize,
                  dX: selectedCollor.dX,
                  dY: selectedCollor.dY,
                  selectedColor: collorColor,
                  assetHeightRespToBox: selectedCollor.assetHeightRespToBox,
                ),
              ],
            )),
      ),
    );
  }
}
