import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:human_canvas/constants/constants.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';

class SVGEditingForm extends StatefulWidget {
  final void Function(bool) onAssetSaved;
  final AssetInfoModel? selectedAssetInfoModel;
  const SVGEditingForm(
      {super.key,
      required this.onAssetSaved,
      required this.selectedAssetInfoModel});

  @override
  State<SVGEditingForm> createState() => _SVGEditingFormState();
}

class _SVGEditingFormState extends State<SVGEditingForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dXController;
  late TextEditingController _dYController;
  late TextEditingController _mirrorDXController;
  late TextEditingController _assetHeightRespToBoxController;
  bool _isUpdatingProgrammatically = false; //Flag to prevent auto-submit
  // String? _svgDataString;
  // String? _svgFileName;
  // void _pickFile() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform
  //         .pickFiles(type: FileType.custom, allowedExtensions: ['svg']);
  //     if (result != null && result.files.isNotEmpty) {
  //       Uint8List? fileBytes = result.files.single.bytes;
  //       if (fileBytes != null) {
  //         setState(() {
  //           _svgDataString = String.fromCharCodes(fileBytes);
  //           _svgFileName = result.files.single.name;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Error Occured while Picking file $e");
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("${widget.initialDx} ${widget.initialDy} in form");
    _initializeControllers();
    //   adding listeners to controllers to trigger auto-submit
    _dXController.addListener(_saveAssetInfo);
    _dYController.addListener(_saveAssetInfo);
    _assetHeightRespToBoxController.addListener(_saveAssetInfo);
    _mirrorDXController.addListener(_saveAssetInfo);
  }

  @override
  void didUpdateWidget(SVGEditingForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers when initialDx or initialDy changes
    // if (widget.selectedAssetInfoModel?.dX !=
    //         double.tryParse(_dXController.text) ||
    //     widget.selectedAssetInfoModel?.dY !=
    //         double.tryParse(_dYController.text) ||
    //     widget.selectedAssetInfoModel?.assetHeightRespToBox !=
    //         double.tryParse(_assetHeightRespToBoxController.text) ||
    //     widget.selectedAssetInfoModel?.mirrorDX !=
    //         double.tryParse(_mirrorDXController.text)) {
    //   _dXController.text = widget.selectedAssetInfoModel!.dX.toString();
    //   _dYController.text = widget.selectedAssetInfoModel!.dY.toString();
    //   _assetHeightRespToBoxController.text =
    //       widget.selectedAssetInfoModel!.assetHeightRespToBox.toString();
    //   _mirrorDXController.text =
    //       widget.selectedAssetInfoModel!.mirrorDX.toString();
    // }
    // Check if selectedAssetInfoModel has changed
    if (widget.selectedAssetInfoModel != oldWidget.selectedAssetInfoModel) {
      _isUpdatingProgrammatically = true;
      _initializeControllers();
      _isUpdatingProgrammatically = false;
    }
  }

  void _initializeControllers() {
    // Initialize or update the controllers with the selected asset's data
    _dXController = TextEditingController(
        text: widget.selectedAssetInfoModel?.dX?.toString() ?? '');
    _dYController = TextEditingController(
        text: widget.selectedAssetInfoModel?.dY?.toString() ?? '');
    _assetHeightRespToBoxController = TextEditingController(
        text: widget.selectedAssetInfoModel?.assetHeightRespToBox?.toString() ??
            '');
    _mirrorDXController = TextEditingController(
        text: widget.selectedAssetInfoModel?.mirrorDX?.toString() ?? '');
  }

  @override
  void dispose() {
    _dXController.removeListener(_saveAssetInfo);
    _dYController.removeListener(_saveAssetInfo);
    _assetHeightRespToBoxController.removeListener(_saveAssetInfo);
    _mirrorDXController.removeListener(_saveAssetInfo);
    _dXController.dispose();
    _dYController.dispose();
    _assetHeightRespToBoxController.dispose();
    _mirrorDXController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _saveAssetInfo() async {
    FileService fileService = FileService();
    if (widget.selectedAssetInfoModel != null) {
      try {
        //   Creating a AssetInfoModel from the form inputs
        AssetInfoModel assetInfoModelFromFormData = AssetInfoModel(
            // these texts are directly parsed - so be carefull about entering the double data
            assetHeightRespToBox:
                double.parse(_assetHeightRespToBoxController.text),
            dY: double.parse(_dYController.text),
            dX: double.parse(_dXController.text),
            mirrorDX: double.parse(_mirrorDXController.text),
            svgDataString: widget.selectedAssetInfoModel!.svgDataString,
            assetName: widget.selectedAssetInfoModel!.assetName ?? 'No Name');
        bool isSaved = await fileService
            .updateSVGAssetModelByKey(assetInfoModelFromFormData);
        print(isSaved.toString());
        widget.onAssetSaved(isSaved);
      } catch (e) {
        print("Error Occured $e");
      }
    }
  }

  String? _validateDouble(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    try {
      double.parse(value);
    } catch (e) {
      return "Please enter a valid number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit SVG Form"),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _dXController,
              decoration: inputDecoration.copyWith(
                labelText: "dX",
              ),
              keyboardType: TextInputType.number,
              validator: _validateDouble,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _dYController,
              decoration: inputDecoration.copyWith(
                labelText: "dY",
              ),
              keyboardType: TextInputType.number,
              validator: _validateDouble,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _mirrorDXController,
              decoration: inputDecoration.copyWith(
                labelText: "MirrorDX",
              ),
              keyboardType: TextInputType.number,
              validator: _validateDouble,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _assetHeightRespToBoxController,
              decoration: inputDecoration.copyWith(
                labelText: "Asset Height Respect To Box",
              ),
              keyboardType: TextInputType.number,
              validator: _validateDouble,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAssetInfo,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text("Save Asset Info"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
