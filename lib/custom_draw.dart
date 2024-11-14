import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'asset_info_model.dart';

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
      padding: const EdgeInsets.only(top: 80.0),
      child: Center(
        child: Container(
            height: boxSize,
            width: boxSize,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),
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

class SvgPainterWithOffsetAndHeightPerc extends StatelessWidget {
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

  Future<String?> getStringFuture() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://leaderboard.sagarfab.com/uploads/add_on/image/623/Frame185.svg"));
      print(
          "https://leaderboard.sagarfab.com/uploads/add_on/image/623/Frame185.svg");
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> getStringFromLocalFile() async {
    try {
      final String svgString = await rootBundle.loadString(assetName);
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
      scaleX: mirror ? -1 : 1,
      child: Transform.translate(
        offset: Offset(boxSize * dX, boxSize * dY),
        child: FutureBuilder<String?>(
            future: getStringFromLocalFile(),
            builder: (context, snapshot) {
              return SvgPicture.string(
                snapshot.data?.replaceAll("#FFFFFF",
                        '#${selectedColor.value.toRadixString(16).substring(2)}') ??
                    "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
                height: boxSize / assetHeightRespToBox,
              );
            }),
      ),
    );
  }
}
