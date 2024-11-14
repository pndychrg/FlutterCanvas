import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:human_canvas/asset_info_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:human_canvas/position_input_form.dart';
import 'custom_draw.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  AssetInfoModel selectedCollor = AssetInfoModel(
      assetLocation: "assets/collor_style1.svg",
      dX: 0.37,
      dY: 0.030,
      assetHeightRespToBox: 3.5);
  AssetInfoModel selectedSleeve = AssetInfoModel(
      assetLocation: "assets/sleeve_style_1.svg",
      dX: .155,
      dY: .135,
      mirrorDX: -.685,
      assetHeightRespToBox: 1.8);
  String selectedElement = "TShirt";

  Color collorColor = Colors.white;
  Color tShirtColor = Colors.white;
  Color sleeveColor = Colors.white;

  String collor = "Collor";
  String torso = "Torso";
  String sleeve = "Sleeve";

  double _selectedElementDx = 0.0;
  double _selectedElementDy = 0.0;

  void updateDxDyWhenElementChanges(AssetInfoModel selectedElementInfoModel) {
    _selectedElementDx = selectedElementInfoModel.dX;
    _selectedElementDy = selectedElementInfoModel.dY;
    print("$_selectedElementDx $_selectedElementDy");
  }

  void updateSelectedElementPosition(double dx, double dy) {
    setState(() {
      // updating the widget selected values
      _selectedElementDx = dx;
      _selectedElementDy = dy;
      // updating the asset's dx dy postion values
      if (selectedElement.contains(collor)) {
        selectedCollor.dX = _selectedElementDx;
        selectedCollor.dY = _selectedElementDy;
      } else {
        //   used else because only collor and sleeves dx dy value are editable ( by code i made it so )
        selectedSleeve.dX = _selectedElementDx;
        selectedSleeve.dY = _selectedElementDy;
      }
    });
  }

  void updateSelectedElement() {
    if (selectedElement.contains(collor)) {
      updateDxDyWhenElementChanges(selectedCollor);
    } else if (selectedElement.contains(sleeve)) {
      updateDxDyWhenElementChanges(selectedSleeve);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            // child: Text('Hello World!'),
            child: Column(
              children: [
                CustomTshirtWithSvgPaint(
                  selectedCollor: selectedCollor,
                  selectedSleeve: selectedSleeve,
                  collorColor: collorColor,
                  torsoColor: tShirtColor,
                  sleeveColor: sleeveColor,
                ),

                Row(
                  children:
                      getTextButtonsFromList("Collor", getCollors(), (model) {
                    setState(() {
                      selectedCollor = model;
                    });
                  }),
                ),

                Row(
                  children:
                      getTextButtonsFromList("Sleeve", getSleeves(), (model) {
                    setState(() {
                      selectedSleeve = model;
                    });
                  }),
                ),
                // Row(
                //   children: [
                //
                //     TextButton(onPressed: () {
                //       setState(() {
                //         selectedCollor = "assets/collor_style1.svg";
                //       });
                //     }, child: Text("Collor 1",)),
                //     SizedBox(width: 30,),
                //
                //     TextButton(onPressed: () {
                //       setState(() {
                //         selectedCollor = "assets/collor_style2.svg";
                //       });
                //     }, child: Text("Collor 2",)),
                //     SizedBox(width: 30,),
                //
                //     TextButton(onPressed: () {
                //       setState(() {
                //         selectedCollor = "assets/collor_style3.svg";
                //       });
                //     }, child: Text("Collor 3",)),
                //     SizedBox(width: 30,),
                //
                //     // TextButton(onPressed: () {
                //     //   setState(() {
                //     //     selectedCollor = "assets/collor_style4.svg";
                //     //   });
                //     // }, child: Text("Collor 4",)),
                //   ],
                // ),
                SizedBox(
                  height: 50,
                ),

                Text("Change color for"),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedElement = collor;
                            updateSelectedElement();
                          });
                        },
                        child: Text(
                          collor,
                          style: TextStyle(
                              color: selectedElement.contains(collor)
                                  ? Colors.black
                                  : Colors.grey),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedElement = torso;
                          });
                        },
                        child: Text(
                          torso,
                          style: TextStyle(
                              color: selectedElement.contains(torso)
                                  ? Colors.black
                                  : Colors.grey),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedElement = sleeve;
                            updateSelectedElement();
                          });
                        },
                        child: Text(
                          sleeve,
                          style: TextStyle(
                              color: selectedElement.contains(sleeve)
                                  ? Colors.black
                                  : Colors.grey),
                        )),
                  ],
                ),
                MaterialColorPicker(
                  onColorChange: (Color color) {
                    setState(() {
                      if (selectedElement.contains(collor)) {
                        collorColor = color;
                        print('collor color $collorColor');
                      } else if (selectedElement.contains(sleeve)) {
                        sleeveColor = color;
                        print('sleeve color $sleeveColor');
                      } else {
                        tShirtColor = color;
                        print('tshirt color $tShirtColor');
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Change Dx Dy Values for selected part"),
                PositionInputForm(
                  initialDx: _selectedElementDx,
                  initialDy: _selectedElementDy,
                  onValuesChanged: updateSelectedElementPosition,
                ),
                // HumanBodyCanvas(),
                // TShirtCanvas()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<AssetInfoModel> getCollors() {
    return [
      AssetInfoModel(
          assetLocation: "assets/collor_style1.svg",
          dX: 0.37,
          dY: 0.030,
          assetHeightRespToBox: 3.5),
      AssetInfoModel(
          assetLocation: "assets/collor_style2.svg",
          dX: 0.37,
          dY: 0.030,
          assetHeightRespToBox: 3.5),
      AssetInfoModel(
          assetLocation: "assets/collor_style3.svg",
          dX: 0.37,
          dY: 0.030,
          assetHeightRespToBox: 3.5),
      AssetInfoModel(
          assetLocation: "assets/collor_style4.svg",
          dX: 0.37,
          dY: 0.065,
          assetHeightRespToBox: 4.5),
    ];
  }

  List<AssetInfoModel> getSleeves() {
    return [
      AssetInfoModel(
          assetLocation: "assets/sleeve_style_1.svg",
          dX: .155,
          dY: .135,
          mirrorDX: -.685,
          assetHeightRespToBox: 1.8),
      AssetInfoModel(
          assetLocation: "assets/sleeve_style_2.svg",
          dX: .165,
          dY: 0.139,
          mirrorDX: -.686,
          assetHeightRespToBox: 4),
    ];
  }

  List<Widget> getTextButtonsFromList(String prefixText, List<dynamic> list,
      Function(AssetInfoModel model) onclick) {
    List<Widget> finalList = [];
    list.forEach((element) {
      finalList.add(
        TextButton(
            onPressed: () {
              onclick(element);
            },
            child: Text(
              "$prefixText ${list.indexOf(element)}",
            )),
      );
    });
    return finalList;
  }
}
