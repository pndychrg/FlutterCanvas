import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';

class SVGList extends StatefulWidget {
  final List<AssetInfoModel?> svgListFromLocalStorage;
  final Function(AssetInfoModel) updateSelectedSVGAssetModel;
  final Function(String) deleteSelectedSVGAssetModel;
  const SVGList({
    super.key,
    required this.svgListFromLocalStorage,
    required this.updateSelectedSVGAssetModel,
    required this.deleteSelectedSVGAssetModel,
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => widget.deleteSelectedSVGAssetModel(
                            assetInfoModel.assetName),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            widget.updateSelectedSVGAssetModel(assetInfoModel),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return null;
            },
          )
        : Text("No SVG Added at the moment");
  }
}
