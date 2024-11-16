import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  String _fileText = '';

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        // Check if the platform is web
        if (kIsWeb) {
          print("Web is used");
          //    Web: use 'bytes' to handle file data
          Uint8List? fileBytes = result.files.single.bytes;
          String fileName = result.files.single.name;
          setState(() {
            _fileText = 'Selected File : $fileName';
          });
          //    If you want to upload the file to server add the HTTP code here
        } else {
          print("Web is not used");
          //   Non Web : Use 'Path' to get File path
          File file = File(result.files.single.path!);
          setState(() {
            _fileText = file.path;
          });
        }
      }
    } catch (e) {
      print("Error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: _pickFile, child: Text("Pick a file"));
  }
}
