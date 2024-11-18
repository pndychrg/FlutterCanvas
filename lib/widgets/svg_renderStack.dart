import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/widgets/svg_painter_with_assetModel.dart';

class SVGRenderStack extends StatefulWidget {
  final List<AssetInfoModel?> svgListFromLocalStorage;
  const SVGRenderStack({super.key, required this.svgListFromLocalStorage});

  @override
  State<SVGRenderStack> createState() => _SVGRenderStackState();
}

class _SVGRenderStackState extends State<SVGRenderStack> {
  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width / 2; // default is 400

    // creating stack childrens list
    List<SvgPainterWithAssetModel> svgStackChildrenList = [];
    widget.svgListFromLocalStorage.forEach((assetInfoModel) {
      if (assetInfoModel != null) {
        svgStackChildrenList.add(SvgPainterWithAssetModel(
            assetInfoModel: assetInfoModel,
            selectedColor: Colors.white,
            boxSize: boxSize));
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
          child: Stack(
            children: svgStackChildrenList,
          ),
        ),
      ),
    );
  }
}
