import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';

class SvgPainterWithAssetModel extends StatefulWidget {
  final AssetInfoModel assetInfoModel;
  // adding selectedColor separate as AssetInfoModel doesn't contain color
  final Color selectedColor;
  final double boxSize;
  bool mirror = false;
  final void Function(bool) onAssetSaved;
  final bool isSelected;
  SvgPainterWithAssetModel(
      {required this.assetInfoModel,
      super.key,
      required this.selectedColor,
      required this.boxSize,
      required this.mirror,
      required this.onAssetSaved,
      required this.isSelected});

  @override
  State<SvgPainterWithAssetModel> createState() =>
      _SvgPainterWithAssetModelState();
}

class _SvgPainterWithAssetModelState extends State<SvgPainterWithAssetModel> {
  void _saveAssetInfo(double newDX, double newDY) async {
    FileService fileService = FileService();
    if (widget.isSelected == true) {
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
          widget.onAssetSaved(isSaved);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        print("isSelected ${widget.isSelected}");
      },
      onPanUpdate: (details) {
        print("Pan update ran");
        late double newDX, newDY;
        if (widget.isSelected) {
          const double sensitivityFactor =
              0.05; // Increase to amplify drag sensitivity

          // Calculate the new normalized dx and dy
          double normalizedDeltaX =
              (details.localPosition.dx * sensitivityFactor) / widget.boxSize;
          double normalizedDeltaY =
              (details.localPosition.dy * sensitivityFactor) / widget.boxSize;

          setState(() {
            newDX =
                (widget.assetInfoModel.dX + normalizedDeltaX).clamp(-0.5, 1.0);
            newDY =
                (widget.assetInfoModel.dY + normalizedDeltaY).clamp(-0.5, 1.0);
          });
          print(
              "Asset DX ${widget.assetInfoModel.dX} DY ${widget.assetInfoModel.dY}");
          print("DX $newDX DY $newDY");
          // calling database function here to update the svg position
          //   udpate the position of selected SVG
          _saveAssetInfo(newDX, newDY);
          print("Is selected: ${widget.isSelected}");
        }
      },
      child: Transform.scale(
        scaleX: widget.mirror ? -1 : 1,
        child: Transform.translate(
            offset: widget.mirror
                ? Offset(widget.boxSize * widget.assetInfoModel.mirrorDX!,
                    widget.boxSize * widget.assetInfoModel.dY)
                : Offset(widget.boxSize * widget.assetInfoModel.dX,
                    widget.boxSize * widget.assetInfoModel.dY),
            child: SvgPicture.string(
              widget.assetInfoModel.svgDataString?.replaceAll(
                      widget.assetInfoModel.svgDataString?.contains("white") ==
                              true
                          ? "white"
                          : "#FFFFFF",
                      '#${widget.assetInfoModel.color.value.toRadixString(16).substring(2)}') ??
                  "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
              height:
                  widget.boxSize / widget.assetInfoModel.assetHeightRespToBox,
            )),
      ),
    );
  }
}
