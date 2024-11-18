import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
  // bool _isUpdatingProgrammatically = false; //Flag to prevent auto-submit
  Timer? _debounceTimer;
  Color selectedColor = Colors.white; // default white
  bool isMirror = false;
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
    super.initState();
    _dXController = TextEditingController(
        text: widget.selectedAssetInfoModel?.dX.toString());
    _dYController = TextEditingController(
        text: widget.selectedAssetInfoModel?.dY.toString());
    _assetHeightRespToBoxController = TextEditingController(
        text: widget.selectedAssetInfoModel?.assetHeightRespToBox.toString());
    _mirrorDXController = TextEditingController(
        text: widget.selectedAssetInfoModel?.mirrorDX.toString());
    // Initialize the selected color from the model if provided
    if (widget.selectedAssetInfoModel != null) {
      selectedColor = widget.selectedAssetInfoModel!.color;
    }
    isMirror = widget.selectedAssetInfoModel?.isMirror ?? false;

    // Add listeners
    _addListeners();
  }

  @override
  void didUpdateWidget(SVGEditingForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedAssetInfoModel != oldWidget.selectedAssetInfoModel) {
      // Update controllers if selectedAssetInfoModel changes
      _dXController.text = widget.selectedAssetInfoModel!.dX.toString();
      _dYController.text = widget.selectedAssetInfoModel!.dY.toString();
      _assetHeightRespToBoxController.text =
          widget.selectedAssetInfoModel!.assetHeightRespToBox.toString();
      _mirrorDXController.text =
          widget.selectedAssetInfoModel!.mirrorDX.toString();
      selectedColor = widget.selectedAssetInfoModel!.color; // Update color
      isMirror = widget.selectedAssetInfoModel?.isMirror ?? false;
    }
  }

  void _addListeners() {
    _dXController.addListener(() => _onValueChanged());
    _dYController.addListener(() => _onValueChanged());
    _assetHeightRespToBoxController.addListener(() => _onValueChanged());
    _mirrorDXController.addListener(() => _onValueChanged());
  }

  void _onValueChanged() {
    // Cancel previous timer if active
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // Set a new debounce timer
    _debounceTimer = Timer(const Duration(seconds: 1), _saveAssetInfo);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _dXController.dispose();
    _dYController.dispose();
    _assetHeightRespToBoxController.dispose();
    _mirrorDXController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _saveAssetInfo() async {
    if (!_formKey.currentState!.validate()) {
      // Form is invalid, return early
      return;
    }
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
          assetName: widget.selectedAssetInfoModel!.assetName ?? 'No Name',
          color: selectedColor,
          isMirror: isMirror,
        );
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edit SVG Form"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _dXController,
                    decoration: inputDecoration.copyWith(
                      labelText: "dX",
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateDouble,
                    enabled: isMirror == false,
                    onChanged: (value) {
                      double parsedValue = double.tryParse(value) ?? 0.0;
                      parsedValue = parsedValue.clamp(-0.50, 1.0);
                      _dXController.text = parsedValue.toStringAsFixed(2);
                      _onValueChanged();
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: double.tryParse(_dXController.text) ?? 0.0,
                    min: -0.50,
                    max: 1.0,
                    divisions: 200,
                    label: _dXController.text,
                    onChanged: isMirror == false
                        ? (value) {
                            setState(() {
                              _dXController.text = value.toStringAsFixed(2);
                            });
                            _onValueChanged();
                          }
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _dYController,
                    decoration: inputDecoration.copyWith(
                      labelText: "dY",
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateDouble,
                    onChanged: (value) {
                      double parsedValue = double.tryParse(value) ?? 0.0;
                      parsedValue = parsedValue.clamp(-0.50, 1.0);
                      _dYController.text = parsedValue.toStringAsFixed(2);
                      _onValueChanged();
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: double.tryParse(_dYController.text) ?? 0.0,
                    min: -0.50,
                    max: 1.0,
                    divisions: 200,
                    label: _dYController.text,
                    onChanged: (value) {
                      setState(() {
                        _dYController.text = value.toStringAsFixed(2);
                      });
                      _onValueChanged();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _mirrorDXController,
                    decoration: inputDecoration.copyWith(
                      labelText: "MirrorDX",
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateDouble,
                    enabled: isMirror,
                    onChanged: (value) {
                      double parsedValue = double.tryParse(value) ?? 0.0;
                      parsedValue = parsedValue.clamp(-1.0, 1.0);
                      _mirrorDXController.text = parsedValue.toStringAsFixed(2);
                      _onValueChanged();
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: double.tryParse(_mirrorDXController.text) ?? 0.0,
                    min: -1.0,
                    max: 1.0,
                    divisions: 200,
                    label: _mirrorDXController.text,
                    onChanged: isMirror
                        ? (value) {
                            setState(() {
                              _mirrorDXController.text =
                                  value.toStringAsFixed(2);
                            });
                            _onValueChanged();
                          }
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _assetHeightRespToBoxController,
                    decoration: inputDecoration.copyWith(
                      labelText: "Asset Height Respect To Box",
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateDouble,
                    onChanged: (value) {
                      double parsedValue = double.tryParse(value) ?? 0.0;
                      parsedValue = parsedValue.clamp(0, 10.0);
                      _assetHeightRespToBoxController.text =
                          parsedValue.toStringAsFixed(2);
                      _onValueChanged();
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value:
                        double.tryParse(_assetHeightRespToBoxController.text) ??
                            0.0,
                    min: 0,
                    max: 10.0,
                    divisions: 200,
                    label: _assetHeightRespToBoxController.text,
                    onChanged: (value) {
                      setState(() {
                        _assetHeightRespToBoxController.text =
                            value.toStringAsFixed(2);
                      });
                      _onValueChanged();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Is Mirror", style: TextStyle(fontSize: 16)),
                Switch(
                  value: isMirror,
                  onChanged: (bool value) {
                    setState(() {
                      isMirror = value;
                    });
                    _onValueChanged();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            MaterialColorPicker(
              selectedColor: null,
              onColorChange: (Color color) {
                setState(() {
                  selectedColor = color;
                });
                _onValueChanged();
              },
            ),
            const SizedBox(height: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
