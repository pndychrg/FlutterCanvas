// all of this code is going to be for web only
import 'dart:convert';

import 'package:human_canvas/models/asset_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileService {
  final String listKey = 'svg_list';

  Future getSharedInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<bool> saveSVGToLocalStorage(String key, String value) async {
    try {
      SharedPreferences prefs = await getSharedInstance();

      //   Retrieve the current list of SVGS as a map
      String? existingData = prefs.getString(listKey);
      // Map<String, String> svgMap = existingData != null
      //     ? Map<String, String>.from(jsonDecode(existingData))
      //     : {};
      List<String> svgList = existingData != null
          ? List<String>.from(jsonDecode(existingData))
          : [];
      //   Add or update the SVG in the list
      svgList.add(key);
      // saving the svg's asset model as a different map with the asssetName as the key
      AssetInfoModel assetInfoModel = AssetInfoModel(
        assetHeightRespToBox: 1,
        dY: 1,
        dX: 1,
        mirrorDX: 1,
        // svgDataString: base64Encode(
        //   utf8.encode(value),
        // ),
        svgDataString: value,
      );
      // saving this AssetInfoModel as a Map in the local Storage
      prefs.setString(key, jsonEncode(assetInfoModel.toJson()));
      // prefs.setString(key, assetInfoModel.toJson().toString());
      // svgMap[key] = value;
      //    Save the updated Map back to local Storage
      prefs.setString("svg_list", jsonEncode(svgList));
      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }

  // Fetch the entire list of SVGs as a map
  Future<List<AssetInfoModel?>> getSVGListFromLocalStorage() async {
    List<AssetInfoModel?> svgAssetList = [];
    try {
      SharedPreferences prefs = await getSharedInstance();
      // Retrieve the SVG map
      String? svgList = prefs.getString(listKey);
      if (svgList != null) {
        // List<AssetInfoModel> svgAssetList = jsonDecode(svgList);
        List decodedSvgList = jsonDecode(svgList).toList();
        print(decodedSvgList.toList());
        for (String svgKey in decodedSvgList) {
          svgAssetList.add(await getSVGAssetModelByKey(svgKey));
        }
        return svgAssetList;
      } else {
        return svgAssetList;
      }
    } catch (e) {
      print("Error retrieving SVG list: $e");
      return svgAssetList;
    }
  }

  //   Fetch a single SVG by it's key
  Future<AssetInfoModel?> getSVGAssetModelByKey(String svgKey) async {
    try {
      SharedPreferences prefs = await getSharedInstance();
      // Retrieve the SVG map
      print(svgKey);
      String? existingData = prefs.getString(svgKey);
      // print(existingData.runtimeType);
      // Map jsonMap = jsonDecode(existingData!);
      if (existingData != null) {
        // print(jsonDecode(existingData).runtimeType);
        return AssetInfoModel.fromJson(jsonDecode(existingData));
      }
      return null;
    } catch (e) {
      print("Error retrieving SVG by key: $e");
      return null;
    }
  }

  /// Remove a single SVG by its key
  Future<bool> removeSvgByKey(String svgKey) async {
    try {
      SharedPreferences prefs = await getSharedInstance();

      // Retrieve the SVG map
      String? existingData = prefs.getString(listKey);
      if (existingData != null) {
        Map<String, String> svgMap =
            Map<String, String>.from(jsonDecode(existingData));
        svgMap.remove(svgKey);

        // Save the updated map back to local storage
        prefs.setString(listKey, jsonEncode(svgMap));
        return true;
      }
      return false;
    } catch (e) {
      print("Error removing SVG by key: $e");
      return false;
    }
  }

  /// Clear the entire SVG list
  Future<bool> clearSvgList() async {
    try {
      SharedPreferences prefs = await getSharedInstance();
      return await prefs.remove(listKey);
    } catch (e) {
      print("Error clearing SVG list: $e");
      return false;
    }
  }
}
