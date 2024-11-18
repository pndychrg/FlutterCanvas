import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';

class SVGList extends StatefulWidget {
  final List<AssetInfoModel?> svgListFromLocalStorage;
  final Function(AssetInfoModel) updateSelectedSVGAssetModel;
  const SVGList({
    super.key,
    required this.svgListFromLocalStorage,
    required this.updateSelectedSVGAssetModel,
  });

  @override
  State<SVGList> createState() => _SVGListState();
}

class _SVGListState extends State<SVGList> {
  @override
  Widget build(BuildContext context) {
    return widget.svgListFromLocalStorage.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.svgListFromLocalStorage.length,
            itemBuilder: (BuildContext context, int index) {
              AssetInfoModel? assetInfoModel =
                  widget.svgListFromLocalStorage[index];
              if (assetInfoModel != null) {
                return ListTile(
                  title: Text(assetInfoModel.assetName),
                  trailing: IconButton(
                    onPressed: () =>
                        widget.updateSelectedSVGAssetModel(assetInfoModel),
                    icon: Icon(Icons.edit),
                  ),
                );
              }
              return null;
            },
          )
        : Text("No SVG Added at the moment");
  }
}
