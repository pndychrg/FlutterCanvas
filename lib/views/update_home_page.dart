import 'package:flutter/material.dart';
import 'package:human_canvas/widgets/file_picker.dart';

class UpdatedHomePage extends StatelessWidget {
  const UpdatedHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilePickerWidget(),
      ],
    );
  }
}
