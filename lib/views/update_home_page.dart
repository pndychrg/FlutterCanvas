import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';
import 'package:human_canvas/widgets/file_picker.dart';
import 'package:human_canvas/widgets/svg_list.dart';
import 'package:human_canvas/widgets/svg_editing_form.dart';

import '../widgets/svg_renderStack.dart';

class UpdatedHomePage extends StatefulWidget {
  const UpdatedHomePage({super.key});

  @override
  State<UpdatedHomePage> createState() => _UpdatedHomePageState();
}

class _UpdatedHomePageState extends State<UpdatedHomePage> {
  AssetInfoModel? selectedSVGAssetModel;
  List<AssetInfoModel?> svgListFromLocalStorage = [];
  final FileService fileService = FileService();
  void updateSvgList() async {
    List<AssetInfoModel?> fetchedSvgMap =
        await fileService.getSVGListFromLocalStorage();
    setState(() {
      svgListFromLocalStorage =
          fetchedSvgMap; //assigned here, so that set state function doesn't have to be async
    });
  }

  void updateSelectedSVGModel(AssetInfoModel selectedSVGModeFromList) {
    setState(() {
      selectedSVGAssetModel = selectedSVGModeFromList;
    });
  }

  void deleteSelectedSVGModel(String assetModelName) async {
    bool isDeleted = await fileService.removeSvgByKey(assetModelName);
    if (isDeleted) {
      updateSvgList();
    }
  }

  void updateSVGListPositions(List<AssetInfoModel?> updatedList) {
    setState(() {
      svgListFromLocalStorage = updatedList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateSvgList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 24,
        ),
        // FilePickerWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("SVG Render Box"),
            FilePickerWidget(
              addedSVGToLocalStorage: () => updateSvgList(),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              children: [
                Text("Current SVG List"),
                SizedBox(
                  height: 10,
                ),
                SVGList(
                  svgListFromLocalStorage: svgListFromLocalStorage,
                  updateSelectedSVGAssetModel: updateSelectedSVGModel,
                  deleteSelectedSVGAssetModel: deleteSelectedSVGModel,
                  updateListInParent: updateSVGListPositions,
                ),
              ],
            )),
            SVGRenderStack(
              svgListFromLocalStorage: svgListFromLocalStorage,
            ),
            Expanded(
              child: Opacity(
                opacity: selectedSVGAssetModel == null ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: selectedSVGAssetModel == null,
                  child: SVGEditingForm(
                    selectedAssetInfoModel: selectedSVGAssetModel,
                    onAssetSaved: (bool isSaved) {
                      if (isSaved) {
                        updateSvgList();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("SVG Asset Updated!")));
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
