import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:human_canvas/constants/constants.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';

class SVGEditingForm extends StatefulWidget {
  final void Function(bool, AssetInfoModel) onAssetSaved;
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
  // bool isMirror = false;
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
    // isMirror = widget.selectedAssetInfoModel?.isMirror ?? false;

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
      // isMirror = widget.selectedAssetInfoModel?.isMirror ?? false;
    }
  }

  void _addListeners() {
    _dXController.addListener(() => _onValueChanged("dX", _dXController.text));
    _dYController.addListener(() => _onValueChanged("dY", _dYController.text));
    _assetHeightRespToBoxController.addListener(() => _onValueChanged(
        "assetHeightRespToBox", _assetHeightRespToBoxController.text));
    _mirrorDXController.addListener(
        () => _onValueChanged("mirrorDX", _mirrorDXController.text));
  }

  void _onValueChanged(String key, String value) {
    if (key != "assetHeightRespToBox" && key != "color" && key != "mirrorDX") {
      try {
        double number = double.parse(value);

        if (-0.50 > number || number > 1) {
          return;
        }
      } catch (e) {}
    }
    if (key == "mirrorDX") {
      try {
        double number = double.parse(value);
        if (number < -1 || number > 1) {
          print("Error in mirrorDX while saving");
          return;
        }
      } catch (e) {
        print(e.toString());
      }
    }

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
          // isMirror: isMirror,
        );
        // bool isSaved = await fileService
        //     .updateSVGAssetModelByKey(assetInfoModelFromFormData);
        //
        // widget.onAssetSaved(isSaved);
        widget.onAssetSaved(true, assetInfoModelFromFormData);
      } catch (e) {
        print("Error Occured $e");
      }
    }
  }

  String? _validateSizeValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    try {
      double number = double.parse(value);
      if (0 > number || number > 50) {
        return "Value out of range. Please enter between -0.5 - 1";
      }
    } catch (e) {
      return "Please enter a valid number";
    }
    return null;
  }

  String? _validatePositionalValues(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    try {
      double number = double.parse(value);
      if (-0.5 > number || number > 1) {
        return "Value out of range. Please enter between -0.5 - 1";
      }
    } catch (e) {
      return "Please enter a valid number";
    }

    return null;
  }

  String? _validateMirrorValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    try {
      double number = double.parse(value);
      if (-1 > number || number > 1) {
        return "Value out of range. Please enter between -0.5 - 1";
      }
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
                    validator: _validatePositionalValues,
                    // enabled: isMirror == false,
                    // onChanged: (value) {
                    //   double parsedValue = double.tryParse(value) ?? 0.0;
                    //   parsedValue = parsedValue.clamp(-0.50, 1.0);
                    //   _dXController.text = parsedValue.toString();
                    //   _onValueChanged();
                    // },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: double.tryParse(_dXController.text) ?? 0.0,
                    min: -0.50,
                    max: 1.0,
                    divisions: 1000,
                    label: _dXController.text,
                    onChanged: (value) {
                      setState(() {
                        _dXController.text = value.toStringAsFixed(3);
                      });
                      _onValueChanged("dX", _dXController.text);
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
                    controller: _dYController,
                    decoration: inputDecoration.copyWith(
                      labelText: "dY",
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validatePositionalValues,
                    // onChanged: (value) {
                    //   double parsedValue = double.tryParse(value) ?? 0.0;
                    //   parsedValue = parsedValue.clamp(-0.50, 1.0);
                    //   _dYController.text = parsedValue.toStringAsFixed(2);
                    //   _onValueChanged(_dYController.text);
                    // },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: double.tryParse(_dYController.text) != null
                        ? double.parse(_dYController.text).clamp(-0.50, 1.0)
                        : 0.0,
                    min: -0.50,
                    max: 1.0,
                    divisions: 1000,
                    label: _dYController.text,
                    onChanged: (value) {
                      setState(() {
                        _dYController.text = value.toStringAsFixed(3);
                      });
                      _onValueChanged("dY", _dYController.text);
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
                    validator: _validateMirrorValue,
                    // enabled: isMirror,
                    // onChanged: (value) {
                    //   double parsedValue = double.tryParse(value) ?? 0.0;
                    //   parsedValue = parsedValue.clamp(-1.0, 1.0);
                    //   _mirrorDXController.text = parsedValue.toStringAsFixed(2);
                    //   _onValueChanged(_mirrorDXController.text);
                    // },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: double.tryParse(_mirrorDXController.text) ?? 0.0,
                    min: -1.0,
                    max: 1.0,
                    divisions: 500,
                    label: _mirrorDXController.text,
                    onChanged: (value) {
                      setState(() {
                        _mirrorDXController.text = value.toStringAsFixed(2);
                      });
                      _onValueChanged("mirrorDX", _mirrorDXController.text);
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
                    controller: _assetHeightRespToBoxController,
                    decoration: inputDecoration.copyWith(
                      labelText: "Asset Height Respect To Box",
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateSizeValue,
                    // onChanged: (value) {
                    //   double parsedValue = double.tryParse(value) ?? 0.0;
                    //   parsedValue = parsedValue.clamp(0, 10.0);
                    //   _assetHeightRespToBoxController.text =
                    //       parsedValue.toStringAsFixed(2);
                    //   _onValueChanged(_assetHeightRespToBoxController.text);
                    // },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value:
                        double.tryParse(_assetHeightRespToBoxController.text) ??
                            0.0,
                    min: 0,
                    max: 50.0,
                    divisions: 500,
                    label: _assetHeightRespToBoxController.text,
                    onChanged: (value) {
                      setState(() {
                        _assetHeightRespToBoxController.text =
                            value.toStringAsFixed(2);
                      });
                      _onValueChanged("assetHeightRespToBox",
                          _assetHeightRespToBoxController.text);
                    },
                  ),
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
                _onValueChanged("color", "");
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
