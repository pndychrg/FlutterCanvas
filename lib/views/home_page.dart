// import 'package:flutter/material.dart';
// import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
// import 'package:human_canvas/constants/constants.dart';
// import 'package:human_canvas/widgets/custom_draw.dart';
// import 'package:human_canvas/widgets/position_input_form.dart';
//
// import '../models/asset_info_model.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   // hard coded asset information
//   AssetInfoModel selectedCollor = AssetInfoModel(
//       assetLocation: "assets/collor_style1.svg",
//       dX: 0.37,
//       dY: 0.030,
//       assetHeightRespToBox: 3.5);
//   AssetInfoModel selectedSleeve = AssetInfoModel(
//       assetLocation: "assets/sleeve_style_1.svg",
//       dX: .155,
//       dY: .135,
//       mirrorDX: -.685,
//       assetHeightRespToBox: 1.8);
//
//   String? selectedElement;
//   bool checkIfElementIsSelected() {
//     return selectedElement != null;
//   }
//
//   // this function clears all selectedElement's values
//   void removeSelectedElements() {
//     selectedElement = null;
//     // dx dy are not updated back to 0 currently
//     // as there is a listener in the Form which will update the Asset's values if dx, dy are updated here
//     // _selectedElementDx = 0.0;
//     // _selectedElementDy = 0.0;
//   }
//
//   Color collorColor = Colors.white;
//   Color tShirtColor = Colors.white;
//   Color sleeveColor = Colors.white;
//
//   // String constants for elements
//   final String collor = "Collor";
//   final String torso = "Torso";
//   final String sleeve = "Sleeve";
//
//   // selected element's positional information
//   double _selectedElementDx = 0.0;
//   double _selectedElementDy = 0.0;
//   double _selectedElementAssetHeightRespToBox = 0.0;
//
//   // this function is used to update the form values whenever different element i.e torso or sleeve is selected
//   void updateDxDyWhenElementChanges(AssetInfoModel selectedElementInfoModel) {
//     _selectedElementDx = selectedElementInfoModel.dX;
//     _selectedElementDy = selectedElementInfoModel.dY;
//     _selectedElementAssetHeightRespToBox =
//         selectedElementInfoModel.assetHeightRespToBox;
//     print(
//         "$_selectedElementDx $_selectedElementDy $_selectedElementAssetHeightRespToBox");
//   }
//
//   // this function updates the element's position value
//   void updateSelectedElementPosition(
//       double dx, double dy, double assetHeightRespToBox) {
//     setState(() {
//       // updating the widget selected values
//       _selectedElementDx = dx;
//       _selectedElementDy = dy;
//       _selectedElementAssetHeightRespToBox = assetHeightRespToBox;
//       // updating the asset's dx dy postion values
//       if (checkIfElementIsSelected() && selectedElement!.contains(collor)) {
//         selectedCollor.dX = _selectedElementDx;
//         selectedCollor.dY = _selectedElementDy;
//         selectedCollor.assetHeightRespToBox =
//             _selectedElementAssetHeightRespToBox;
//       } else {
//         //   used else because only collor and sleeves dx dy value are editable ( by code i made it so )
//         selectedSleeve.dX = _selectedElementDx;
//         selectedSleeve.dY = _selectedElementDy;
//         selectedSleeve.assetHeightRespToBox =
//             _selectedElementAssetHeightRespToBox;
//       }
//     });
//   }
//
//   // this function updates the selected Element
//   void updateSelectedElement() {
//     if (checkIfElementIsSelected() && selectedElement!.contains(collor)) {
//       updateDxDyWhenElementChanges(selectedCollor);
//     } else if (checkIfElementIsSelected() &&
//         selectedElement!.contains(sleeve)) {
//       updateDxDyWhenElementChanges(selectedSleeve);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CustomTshirtWithSvgPaint(
//           selectedCollor: selectedCollor,
//           selectedSleeve: selectedSleeve,
//           collorColor: collorColor,
//           torsoColor: tShirtColor,
//           sleeveColor: sleeveColor,
//         ),
//         // Container for Add on Selection
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 color: Colors.grey, // Color of the top border
//                 width: 2.0, // Thickness of the top border
//               ),
//             ),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(10),
//               topRight: Radius.circular(10),
//             ),
//           ),
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Container for Add Ons
//               SizedBox(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Select Add ons",
//                       style: headingStyle,
//                     ),
//                     // Collors Selection Button
//                     Wrap(
//                       // mainAxisSize: MainAxisSize.min,
//                       alignment: WrapAlignment.start,
//                       spacing: 5,
//                       children: getTextButtonsFromList("Collor", getCollors(),
//                           (model) {
//                         setState(() {
//                           selectedCollor = model;
//                         });
//                       }),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     // Sleeves Selection Button
//                     Wrap(
//                       alignment: WrapAlignment.start,
//                       spacing: 5,
//                       children: getTextButtonsFromList("Sleeve", getSleeves(),
//                           (model) {
//                         setState(() {
//                           selectedSleeve = model;
//                         });
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               // Container for Colors Selection
//               SizedBox(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Select Element to customize",
//                       style: headingStyle,
//                     ),
//                     // Hard coded list of elements
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 // check if selectedElement is already Collor
//                                 if (checkIfElementIsSelected() &&
//                                     selectedElement!.contains(collor)) {
//                                   //   remove all selections
//                                   removeSelectedElements();
//                                 } else {
//                                   selectedElement = collor;
//                                   updateSelectedElement();
//                                 }
//                               });
//                             },
//                             child: Text(collor,
//                                 style: TextStyle(
//                                   color: checkIfElementIsSelected()
//                                       ? (selectedElement!.contains(collor)
//                                           ? Colors.black
//                                           : Colors.grey)
//                                       : Colors.grey,
//                                 )),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 30,
//                         ),
//                         Expanded(
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (checkIfElementIsSelected() &&
//                                       selectedElement!.contains(torso)) {
//                                     //   remove all selections
//                                     removeSelectedElements();
//                                   } else {
//                                     selectedElement = torso;
//                                   }
//                                 });
//                               },
//                               child: Text(
//                                 torso,
//                                 style: TextStyle(
//                                   color: checkIfElementIsSelected()
//                                       ? (selectedElement!.contains(torso)
//                                           ? Colors.black
//                                           : Colors.grey)
//                                       : Colors.grey,
//                                 ),
//                               )),
//                         ),
//                         SizedBox(
//                           width: 30,
//                         ),
//                         Expanded(
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (checkIfElementIsSelected() &&
//                                       selectedElement!.contains(sleeve)) {
//                                     //   remove all selections
//                                     removeSelectedElements();
//                                   } else {
//                                     selectedElement = sleeve;
//                                     updateSelectedElement();
//                                   }
//                                 });
//                               },
//                               child: Text(
//                                 sleeve,
//                                 style: TextStyle(
//                                   color: checkIfElementIsSelected()
//                                       ? (selectedElement!.contains(sleeve)
//                                           ? Colors.black
//                                           : Colors.grey)
//                                       : Colors.grey,
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Pick a Color for Element ",
//                 style: headingStyle,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Opacity(
//                 opacity: selectedElement == null ? 0.5 : 1.0,
//                 child: IgnorePointer(
//                   ignoring: selectedElement == null,
//                   child: MaterialColorPicker(
//                     selectedColor: null,
//                     onColorChange: (Color color) {
//                       setState(() {
//                         if (checkIfElementIsSelected() &&
//                             selectedElement!.contains(collor)) {
//                           collorColor = color;
//                           print('collor color $collorColor');
//                         } else if (checkIfElementIsSelected() &&
//                             selectedElement!.contains(sleeve)) {
//                           sleeveColor = color;
//                           print('sleeve color $sleeveColor');
//                         } else {
//                           tShirtColor = color;
//                           print('tshirt color $tShirtColor');
//                         }
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               // Form Field Box
//               SizedBox(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Change Properties for selected part",
//                       style: headingStyle,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Opacity(
//                       opacity: selectedElement == null ? 0.5 : 1.0,
//                       child: IgnorePointer(
//                         ignoring: selectedElement == null,
//                         child: PositionInputForm(
//                           initialDx: _selectedElementDx,
//                           initialDy: _selectedElementDy,
//                           initialAssetHeightRespToBox:
//                               _selectedElementAssetHeightRespToBox,
//                           onValuesChanged: updateSelectedElementPosition,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // HumanBodyCanvas(),
//         // TShirtCanvas()
//       ],
//     );
//   }
//
//   List<AssetInfoModel> getCollors() {
//     return [
//       AssetInfoModel(
//           assetLocation: "assets/collor_style1.svg",
//           dX: 0.37,
//           dY: 0.030,
//           assetHeightRespToBox: 3.5),
//       AssetInfoModel(
//           assetLocation: "assets/collor_style2.svg",
//           dX: 0.37,
//           dY: 0.030,
//           assetHeightRespToBox: 3.5),
//       AssetInfoModel(
//           assetLocation: "assets/collor_style3.svg",
//           dX: 0.37,
//           dY: 0.030,
//           assetHeightRespToBox: 3.5),
//       AssetInfoModel(
//           assetLocation: "assets/collor_style4.svg",
//           dX: 0.37,
//           dY: 0.065,
//           assetHeightRespToBox: 4.5),
//     ];
//   }
//
//   List<AssetInfoModel> getSleeves() {
//     return [
//       AssetInfoModel(
//           assetLocation: "assets/sleeve_style_1.svg",
//           dX: .155,
//           dY: .135,
//           mirrorDX: -.685,
//           assetHeightRespToBox: 1.8),
//       AssetInfoModel(
//           assetLocation: "assets/sleeve_style_2.svg",
//           dX: .165,
//           dY: 0.139,
//           mirrorDX: -.686,
//           assetHeightRespToBox: 4),
//     ];
//   }
//
//   List<Widget> getTextButtonsFromList(String prefixText, List<dynamic> list,
//       Function(AssetInfoModel model) onclick) {
//     List<Widget> finalList = [];
//     list.forEach((element) {
//       finalList.add(
//         ElevatedButton(
//           onPressed: () {
//             onclick(element);
//           },
//           child: Text(
//             "$prefixText ${list.indexOf(element) + 1}",
//           ),
//         ),
//       );
//     });
//     return finalList;
//   }
// }
