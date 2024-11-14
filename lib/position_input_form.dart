import 'package:flutter/material.dart';

class PositionInputForm extends StatefulWidget {
  final double initialDx;
  final double initialDy;
  final Function(double, double) onValuesChanged;
  const PositionInputForm(
      {required this.initialDx,
      required this.initialDy,
      required this.onValuesChanged});

  @override
  State<PositionInputForm> createState() => _PositionInputFormState();
}

class _PositionInputFormState extends State<PositionInputForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dXController;
  late TextEditingController _dYController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${widget.initialDx} ${widget.initialDy} in form");
    _dXController = TextEditingController(text: widget.initialDx.toString());
    _dYController = TextEditingController(text: widget.initialDy.toString());
    //   adding listeners to controllers to trigger auto-submit
    _dXController.addListener(_autoSubmitForm);
    _dYController.addListener(_autoSubmitForm);
  }

  @override
  void didUpdateWidget(PositionInputForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers when initialDx or initialDy changes
    if (widget.initialDx != double.tryParse(_dXController.text) ||
        widget.initialDy != double.tryParse(_dYController.text)) {
      _dXController.text = widget.initialDx.toString();
      _dYController.text = widget.initialDy.toString();
    }
  }

  @override
  void dispose() {
    _dXController.removeListener(_autoSubmitForm);
    _dYController.removeListener(_autoSubmitForm);
    _dXController.dispose();
    _dYController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _autoSubmitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      double dx = double.parse(_dXController.text);
      double dy = double.parse(_dYController.text);

      print("Double Value DX: $dx \nDouble Value DY : $dy");
      widget.onValuesChanged(dx, dy);
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
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _dXController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Enter DX"),
              validator: _validateDouble,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _dYController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Enter DY"),
              validator: _validateDouble,
            ),
          ),
        ],
      ),
    );
  }
}
