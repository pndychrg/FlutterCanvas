import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/widgets/svg_painter_withPosition.dart';
import 'package:human_canvas/widgets/svg_painter_with_assetModel.dart';

class SVGRenderStack extends StatefulWidget {
  final List<AssetInfoModel?> svgListFromLocalStorage;
  final int? selectedSVGAssetModelIndex;
  final void Function(bool, AssetInfoModel updatedAssetModel) onAssetSaved;
  const SVGRenderStack({
    super.key,
    required this.svgListFromLocalStorage,
    required this.selectedSVGAssetModelIndex,
    required this.onAssetSaved,
  });
  @override
  State<SVGRenderStack> createState() => _SVGRenderStackState();
}

class _SVGRenderStackState extends State<SVGRenderStack> {
  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width / 3; // default is 400

    // creating stack childrens list
    // List<SvgPainterWithAssetModel> svgStackChildrenList = [];

    List<SvgPainterWithposition> svgPainterStackChildrenList = [];
    widget.svgListFromLocalStorage.forEach((assetInfoModel) {
      int index = widget.svgListFromLocalStorage.indexOf(assetInfoModel);
      if (assetInfoModel != null) {
        // checking if the mirrorDx value is set to -1
        if (assetInfoModel.mirrorDX == -1) {
          // svgStackChildrenList.add(SvgPainterWithAssetModel(
          //   assetInfoModel: assetInfoModel,
          //   selectedColor: Colors.white,
          //   boxSize: boxSize,
          //   mirror: false,
          //   isSelected: index == widget.selectedSVGAssetModelIndex,
          //   onAssetSaved: widget.onAssetSaved,
          // ));
          svgPainterStackChildrenList.add(SvgPainterWithposition(
            assetInfoModel: assetInfoModel,
            selectedColor: Colors.white,
            boxSize: boxSize,
            mirror: false,
            isSelected: index == widget.selectedSVGAssetModelIndex,
            onAssetSaved: widget.onAssetSaved,
          ));
        } else {
          // adding it two times as left and mirrored right
          // svgStackChildrenList.add(SvgPainterWithAssetModel(
          //   assetInfoModel: assetInfoModel,
          //   selectedColor: Colors.white,
          //   boxSize: boxSize,
          //   mirror: false,
          //   isSelected: index == widget.selectedSVGAssetModelIndex,
          //   onAssetSaved: widget.onAssetSaved,
          // ));
          // svgStackChildrenList.add(SvgPainterWithAssetModel(
          //   assetInfoModel: assetInfoModel,
          //   selectedColor: Colors.white,
          //   boxSize: boxSize,
          //   mirror: true,
          //   isSelected: index == widget.selectedSVGAssetModelIndex,
          //   onAssetSaved: widget.onAssetSaved,
          // ));
          svgPainterStackChildrenList.add(SvgPainterWithposition(
            assetInfoModel: assetInfoModel,
            selectedColor: Colors.white,
            boxSize: boxSize,
            mirror: false,
            isSelected: index == widget.selectedSVGAssetModelIndex,
            onAssetSaved: widget.onAssetSaved,
          ));
          svgPainterStackChildrenList.add(SvgPainterWithposition(
            assetInfoModel: assetInfoModel,
            selectedColor: Colors.white,
            boxSize: boxSize,
            mirror: true,
            isSelected: index == widget.selectedSVGAssetModelIndex,
            onAssetSaved: widget.onAssetSaved,
          ));
        }
      }
    });

    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
                color: Colors.grey
                    .withOpacity(0.2), // Grey shadow color with subtle opacity
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3), // Changes position of shadow
              ),
            ],
          ),
          // child: InteractiveViewer(
          //   clipBehavior: Clip.none,
          //   minScale: 0.1,
          //   maxScale: 2.5,
          //   child: Stack(
          //     children: svgPainterStackChildrenList,
          //   ),
          // ),
          child: Stack(
            // children: svgStackChildrenList,
            children: svgPainterStackChildrenList,
          ),
        ),
      ),
    );
  }
}
