import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  String _fileText = 'Pick a File';
  File? _cachedFile;
  Uint8List? _svgBytes; //For storing SVG content on web

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
            setLocalStorage(fileName, base64Data);
            setState(() {
              _fileText = 'SVG file loaded into memory: $fileName';
              _svgBytes = fileBytes; // Store in memory
            });
          }
          //    If you want to upload the file to server add the HTTP code here
        } else {
          // print("Web is not used");
          //   Non Web : Use 'Path' to get File path
          String? filePath = result.files.single.path;
          if (filePath != null) {
            String tempPath = (await getTemporaryDirectory()).path;
            String cachedFilePath = '$tempPath/$fileName';

            File file = File(filePath);
            await file.copy(cachedFilePath);

            setState(() {
              _fileText = 'Stored SVG in cache: $cachedFilePath';
              _cachedFile = File(cachedFilePath);
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

  void setLocalStorage(String key, String value) async {
    //   using Flutter's SharedPref package to save in local storage for web
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print("SharedPrefs ran");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _pickFile, child: Text("Pick a file")),
        SizedBox(
          height: 10,
        ),
        Text(_fileText),
        SizedBox(
          height: 10,
        ),
        if (_svgBytes != null)
          SvgPicture.memory(
            _svgBytes!,
            width: 200,
            height: 200,
            placeholderBuilder: (context) => CircularProgressIndicator(),
          )
      ],
    );
  }
}
