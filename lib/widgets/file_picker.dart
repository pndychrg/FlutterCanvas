import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';
import 'package:path_provider/path_provider.dart';

class FilePickerWidget extends StatefulWidget {
  final Function addedSVGToLocalStorage;
  const FilePickerWidget({super.key, required this.addedSVGToLocalStorage});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  // Uint8List? _svgBytes; //For storing SVG content on web
  FileService fileService = FileService();
  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['svg']);
      if (result != null && result.files.isNotEmpty) {
        String fileName = result.files.single.name;
        // Check if the platform is web
        // Web: Use bytes to handle file data
        if (kIsWeb) {
          // print("Web is used");
          //    Web: use 'bytes' to handle file data
          Uint8List? fileBytes = result.files.single.bytes;
          if (fileBytes != null) {
            // fileService.saveSVGToLocalStorage(fileName, base64Data);
            //   Testing code
            String svgString = String.fromCharCodes(fileBytes);
            // print()
            print(svgString);
            AssetInfoModel tempAssetInfoModel = AssetInfoModel(
              assetHeightRespToBox: 3.125,
              dY: 0.125,
              dX: 0.125,
              mirrorDX: 0,
              svgDataString: svgString,
              assetName: fileName,
              color: Colors.white,
              isMirror: false,
            );
            print("tempAssetInfoModel made");
            bool isSaved =
                await fileService.saveSVGToLocalStorage(tempAssetInfoModel);
            if (isSaved) {
              widget.addedSVGToLocalStorage();
            }
            print("is file saved: $isSaved");
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
          }
        }
      }
    } catch (e) {
      print("Error occured in FilePicker file$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: _pickFile, child: Text("Pick a file"));
  }
}
