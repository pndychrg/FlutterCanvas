import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';

class SvgPainterWithposition extends StatefulWidget {
  final AssetInfoModel assetInfoModel;
  final Color selectedColor;
  final double boxSize;
  bool mirror = false;
  final void Function(bool, AssetInfoModel) onAssetSaved;
  final bool isSelected;
  SvgPainterWithposition(
      {super.key,
      required this.assetInfoModel,
      required this.selectedColor,
      required this.boxSize,
      required this.onAssetSaved,
      required this.isSelected,
      required this.mirror});

  @override
  State<SvgPainterWithposition> createState() => _SvgPainterWithpositionState();
}

class _SvgPainterWithpositionState extends State<SvgPainterWithposition> {
  Timer? _debounceTimer;

  void _saveAssetInfo(double newDX, double newDY, double mirrorDX) async {
    print("_saveAssetInfo ran in SVGPainterwithPosition Widget");
    FileService fileService = FileService();
    print(widget.mirror);
    if (widget.isSelected == true && widget.mirror == false) {
      try {
        //   Creating a assetInfoModel with updated positions
        AssetInfoModel assetInfoModelWithUpdatedPositions = AssetInfoModel(
            assetHeightRespToBox: widget.assetInfoModel.assetHeightRespToBox,
            dY: newDY,
            dX: newDX,
            mirrorDX: widget.assetInfoModel.mirrorDX,
            svgDataString: widget.assetInfoModel.svgDataString,
            assetName: widget.assetInfoModel.assetName,
            color: widget.assetInfoModel.color);

        bool isSaved = await fileService
            .updateSVGAssetModelByKey(assetInfoModelWithUpdatedPositions);
        if (isSaved == true) {
          widget.onAssetSaved(isSaved, assetInfoModelWithUpdatedPositions);
        }
      } catch (e) {
        print(e.toString());
      }
    } else if (widget.isSelected == true && widget.mirror == true) {
      try {
        //   Creating a assetInfoModel with updated positions
        AssetInfoModel assetInfoModelWithUpdatedPositions = AssetInfoModel(
            assetHeightRespToBox: widget.assetInfoModel.assetHeightRespToBox,
            dY: newDY,
            dX: widget.assetInfoModel.dX,
            mirrorDX: mirrorDX,
            svgDataString: widget.assetInfoModel.svgDataString,
            assetName: widget.assetInfoModel.assetName,
            color: widget.assetInfoModel.color);

        bool isSaved = await fileService
            .updateSVGAssetModelByKey(assetInfoModelWithUpdatedPositions);
        if (isSaved == true) {
          widget.onAssetSaved(isSaved, assetInfoModelWithUpdatedPositions);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.mirror
          ? (widget.assetInfoModel.mirrorDX! * widget.boxSize)
          : widget.assetInfoModel.dX * widget.boxSize,
      top: widget.assetInfoModel.dY * widget.boxSize,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (widget.isSelected) {
            if (widget.mirror == false) {
              late double newDX, newDY;

              setState(() {
                //   calculate new position as a normalized range
                newDX = (widget.assetInfoModel.dX +
                        details.delta.dx / widget.boxSize)
                    .clamp(-0.5, 1);
                newDY = (widget.assetInfoModel.dY +
                        details.delta.dy / widget.boxSize)
                    .clamp(-0.5, 1);

                widget.assetInfoModel.dX = newDX;
                widget.assetInfoModel.dY = newDY;
              });

              // Cancel the previous timer if still running
              _debounceTimer?.cancel();
              // start a new timer
              _debounceTimer = Timer(const Duration(seconds: 1), () {
                _saveAssetInfo(newDX, newDY, widget.assetInfoModel.mirrorDX!);
              });
            } else {
              late double newMirrorDX, newDY;

              setState(() {
                //   calculate new position as a normalized range
                newMirrorDX = (widget.assetInfoModel.mirrorDX! +
                        details.delta.dx / widget.boxSize)
                    .clamp(-0.5, 1);
                newDY = (widget.assetInfoModel.dY +
                        details.delta.dy / widget.boxSize)
                    .clamp(-0.5, 1);

                widget.assetInfoModel.mirrorDX = newMirrorDX;
                widget.assetInfoModel.dY = newDY;
              });

              // Cancel the previous timer if still running
              _debounceTimer?.cancel();
              // start a new timer
              _debounceTimer = Timer(const Duration(seconds: 1), () {
                _saveAssetInfo(widget.assetInfoModel.dX, newDY,
                    widget.assetInfoModel.mirrorDX!);
              });
            }
          }
        },
        child: Transform.scale(
          scaleX: widget.mirror ? -1 : 1,
          alignment: Alignment.center,
          child: SvgPicture.string(
            widget.assetInfoModel.svgDataString?.replaceAll(
                    widget.assetInfoModel.svgDataString?.contains("white") ==
                            true
                        ? "white"
                        : "#FFFFFF",
                    '#${widget.assetInfoModel.color.value.toRadixString(16).substring(2)}') ??
                "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
            height: widget.boxSize / widget.assetInfoModel.assetHeightRespToBox,
          ),
        ),
      ),
    );
  }
}
