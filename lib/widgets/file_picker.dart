import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:human_canvas/services/file_service.dart';
import 'package:path_provider/path_provider.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  String _fileText = 'Pick a File';
  // Uint8List? _svgBytes; //For storing SVG content on web
  FileService fileService = FileService();
  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['svg']);
      if (result != null && result.files.isNotEmpty) {
        String fileName = result.files.single.name;
        // Check if the platform is web
        if (kIsWeb) {
          print("Web is used");
          //    Web: use 'bytes' to handle file data
          Uint8List? fileBytes = result.files.single.bytes;
          if (fileBytes != null) {
            // Web: Use bytes to handle file data
            String base64Data = base64Encode(fileBytes);
            // fileService.saveSVGToLocalStorage(fileName, base64Data);
            setState(() {
              _fileText = 'SVG file loaded into memory: $fileName';
              // _svgBytes = fileBytes; // Store in memory
            });

            //   Testing code
            String svgString = String.fromCharCodes(fileBytes);
            // print(svgString);
            // bool isSaved =
            //     await fileService.saveSVGToLocalStorage(fileName, svgString);
          }
          //    If you want to upload the file to server add the HTTP code here
        } else {
          // print("Web is not used");
          //   Non Web : Use 'Path' to get File path
          //  WARNING : THIS CODE IS NOT YET TESTED SO IT MAY OR MAY NOT WORK
          String? filePath = result.files.single.path;
          if (filePath != null) {
            String tempPath = (await getTemporaryDirectory()).path;
            String cachedFilePath = '$tempPath/$fileName';

            File file = File(filePath);
            await file.copy(cachedFilePath);

            setState(() {
              _fileText = 'Stored SVG in cache: $cachedFilePath';
            });
          }
        }
      }
    } catch (e) {
      print("Error occured $e");
      setState(() {
        _fileText = 'Error: Could not load the file';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: _pickFile, child: Text("Pick a file")),
        Text(_fileText),
      ],
    );
  }
}
