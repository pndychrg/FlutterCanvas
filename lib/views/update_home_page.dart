import 'package:flutter/material.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:human_canvas/services/file_service.dart';
import 'package:human_canvas/widgets/file_picker.dart';
import 'package:human_canvas/widgets/svg_list.dart';

class UpdatedHomePage extends StatefulWidget {
  const UpdatedHomePage({super.key});

  @override
  State<UpdatedHomePage> createState() => _UpdatedHomePageState();
}

class _UpdatedHomePageState extends State<UpdatedHomePage> {
  List<AssetInfoModel?> svgListFromLocalStorage = [];
  final FileService fileService = FileService();
  void updateSvgList() async {
    List<AssetInfoModel?> fetchedSvgMap =
        await fileService.getSVGListFromLocalStorage();
    setState(() {
      svgListFromLocalStorage =
          fetchedSvgMap; //assigned here, so that set state function doesn't have to be async
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateSvgList();
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width / 2; // default is 400
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilePickerWidget(),
        SVGList(
          svgListFromLocalStorage: svgListFromLocalStorage,
        ),
      ],
    );
  }
}
