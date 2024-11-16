import 'package:flutter/material.dart';
import 'package:human_canvas/constants/constants.dart';

class PositionInputForm extends StatefulWidget {
  final double initialDx;
  final double initialDy;
  final double initialAssetHeightRespToBox;
  final Function(double, double, double) onValuesChanged;
  const PositionInputForm({
    required this.initialDx,
    required this.initialDy,
    required this.initialAssetHeightRespToBox,
    required this.onValuesChanged,
  });

  @override
  State<PositionInputForm> createState() => _PositionInputFormState();
}

class _PositionInputFormState extends State<PositionInputForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dXController;
  late TextEditingController _dYController;
  late TextEditingController _assetHeightRespToBoxController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("${widget.initialDx} ${widget.initialDy} in form");
    _dXController = TextEditingController(text: widget.initialDx.toString());
    _dYController = TextEditingController(text: widget.initialDy.toString());
    _assetHeightRespToBoxController = TextEditingController(
        text: widget.initialAssetHeightRespToBox.toString());
    //   adding listeners to controllers to trigger auto-submit
    _dXController.addListener(_autoSubmitForm);
    _dYController.addListener(_autoSubmitForm);
  }

  @override
  void didUpdateWidget(PositionInputForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers when initialDx or initialDy changes
    if (widget.initialDx != double.tryParse(_dXController.text) ||
        widget.initialDy != double.tryParse(_dYController.text) ||
        widget.initialAssetHeightRespToBox !=
            double.tryParse(_assetHeightRespToBoxController.text)) {
      _dXController.text = widget.initialDx.toString();
      _dYController.text = widget.initialDy.toString();
      _assetHeightRespToBoxController.text =
          widget.initialAssetHeightRespToBox.toString();
    }
  }

  @override
  void dispose() {
    _dXController.removeListener(_autoSubmitForm);
    _dYController.removeListener(_autoSubmitForm);
    _assetHeightRespToBoxController.removeListener(_autoSubmitForm);
    _dXController.dispose();
    _dYController.dispose();
    _assetHeightRespToBoxController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _autoSubmitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      double dx = double.parse(_dXController.text);
      double dy = double.parse(_dYController.text);
      double assetHeightRespToBox =
          double.parse(_assetHeightRespToBoxController.text);
      print(
          "Double Value DX: $dx \nDouble Value DY : $dy\n Asset Height Respect to Box : $assetHeightRespToBox");
      widget.onValuesChanged(dx, dy, assetHeightRespToBox);
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
          Text(
            "• Enter Positions",
            style: headingStyle.copyWith(fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dXController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: inputDecoration,
                  validator: _validateDouble,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  controller: _dYController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: inputDecoration.copyWith(labelText: "Enter Dy"),
                  validator: _validateDouble,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _assetHeightRespToBoxController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: inputDecoration.copyWith(
                labelText: "Enter Asset Height Respective to Box"),
            validator: _validateDouble,
          ),
        ],
      ),
    );
  }
}
