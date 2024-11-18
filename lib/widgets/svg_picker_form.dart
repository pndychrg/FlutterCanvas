import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:human_canvas/constants/constants.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';

class SvgPickerForm extends StatefulWidget {
  final void Function(bool) onAssetSaved;
  const SvgPickerForm({super.key, required this.onAssetSaved});

  @override
  State<SvgPickerForm> createState() => _SvgPickerFormState();
}

class _SvgPickerFormState extends State<SvgPickerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dXController = TextEditingController();
  final TextEditingController _dYController = TextEditingController();
  final TextEditingController _mirrorDXController = TextEditingController();
  final TextEditingController _assetHeightRespToBoxController =
      TextEditingController();
  String? _svgDataString;
  String? _svgFileName;
  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['svg']);
      if (result != null && result.files.isNotEmpty) {
        Uint8List? fileBytes = result.files.single.bytes;
        if (fileBytes != null) {
          setState(() {
            _svgDataString = String.fromCharCodes(fileBytes);
            _svgFileName = result.files.single.name;
          });
        }
      }
    } catch (e) {
      print("Error Occured while Picking file $e");
    }
  }

  void _saveAssetInfo() async {
    FileService fileService = FileService();
    try {
      //   Creating a AssetInfoModel from the form inputs
      AssetInfoModel assetInfoModelFromFormData = AssetInfoModel(
          // these texts are directly parsed - so be carefull about entering the double data
          assetHeightRespToBox:
              double.parse(_assetHeightRespToBoxController.text),
          dY: double.parse(_dYController.text),
          dX: double.parse(_dXController.text),
          mirrorDX: double.parse(_mirrorDXController.text),
          svgDataString: _svgDataString,
          assetName: _svgFileName ?? 'No Name');
      bool isSaved =
          await fileService.saveSVGToLocalStorage(assetInfoModelFromFormData);
      print(isSaved.toString());
      widget.onAssetSaved(isSaved);
    } catch (e) {
      print("Error Occured $e");
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // this row is to pick the svg file
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select SVG File",
                    style: headingStyle,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                          onPressed: _pickFile,
                          child: Text("Pick a SVG File ")),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "File Name : ${_svgFileName ?? 'Not Picked Yet'}",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              )),
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
          Center(
            child: ElevatedButton(
                onPressed: _saveAssetInfo,
                child: const Text("Save Asset Info")),
          )
        ],
      ),
    );
  }
}
