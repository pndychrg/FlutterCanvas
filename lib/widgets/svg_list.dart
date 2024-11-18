import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';

class SVGList extends StatefulWidget {
  final List<AssetInfoModel?> svgListFromLocalStorage;
  final Function(AssetInfoModel) updateSelectedSVGAssetModel;
  final Function(String) deleteSelectedSVGAssetModel;
  final Function(List<AssetInfoModel?>) updateListInParent;
  const SVGList({
    super.key,
    required this.svgListFromLocalStorage,
    required this.updateSelectedSVGAssetModel,
    required this.deleteSelectedSVGAssetModel,
    required this.updateListInParent,
  });

  @override
  State<SVGList> createState() => _SVGListState();
}

class _SVGListState extends State<SVGList> {
  // Swap two items in the list based on their indices
  void _swapItems(int oldIndex, int newIndex) {
    if (newIndex < 0 || newIndex >= widget.svgListFromLocalStorage.length) {
      return;
    }
    setState(() {
      final temp = widget.svgListFromLocalStorage[oldIndex];
      widget.svgListFromLocalStorage[oldIndex] =
          widget.svgListFromLocalStorage[newIndex];
      widget.svgListFromLocalStorage[newIndex] = temp;
    });

    // Notify parent widget about the updated list
    widget.updateListInParent(widget.svgListFromLocalStorage);
  }

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
                      // Add Up and Down buttons
                      IconButton(
                        onPressed: () {
                          if (index > 0) {
                            _swapItems(index, index - 1); // Move up
                          }
                        },
                        icon: Icon(Icons.arrow_upward),
                      ),
                      IconButton(
                        onPressed: () {
                          if (index <
                              widget.svgListFromLocalStorage.length - 1) {
                            _swapItems(index, index + 1); // Move down
                          }
                        },
                        icon: Icon(Icons.arrow_downward),
                      ),
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
