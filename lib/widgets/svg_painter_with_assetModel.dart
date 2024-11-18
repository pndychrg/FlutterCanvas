import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:human_canvas/models/asset_info_model.dart';

class SvgPainterWithAssetModel extends StatefulWidget {
  final AssetInfoModel assetInfoModel;
  // adding selectedColor separate as AssetInfoModel doesn't contain color
  final Color selectedColor;
  final double boxSize;
  bool mirror = false;
  SvgPainterWithAssetModel({
    required this.assetInfoModel,
    super.key,
    required this.selectedColor,
    required this.boxSize,
    required this.mirror,
  });

  @override
  State<SvgPainterWithAssetModel> createState() =>
      _SvgPainterWithAssetModelState();
}

class _SvgPainterWithAssetModelState extends State<SvgPainterWithAssetModel> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: widget.mirror ? -1 : 1,
      child: Transform.translate(
          offset: widget.mirror
              ? Offset(widget.boxSize * widget.assetInfoModel.mirrorDX!,
                  widget.boxSize * widget.assetInfoModel.dY)
              : Offset(widget.boxSize * widget.assetInfoModel.dX,
                  widget.boxSize * widget.assetInfoModel.dY),
          child: SvgPicture.string(
            widget.assetInfoModel.svgDataString?.replaceAll("#FFFFFF",
                    '#${widget.assetInfoModel.color.value.toRadixString(16).substring(2)}') ??
                "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
            height: widget.boxSize / widget.assetInfoModel.assetHeightRespToBox,
          )),
    );
  }
}
