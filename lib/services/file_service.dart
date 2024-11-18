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

  Future<bool> saveSVGToLocalStorage(AssetInfoModel assetInfoModel) async {
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
      svgList.add(assetInfoModel.assetName);
      // saving the svg's asset model as a different map with the asssetName as the key

      // saving this AssetInfoModel as a Map in the local Storage
      prefs.setString(
          assetInfoModel.assetName, jsonEncode(assetInfoModel.toJson()));
      // prefs.setString(key, assetInfoModel.toJson().toString());
      // svgMap[key] = value;
      //    Save the updated Map back to local Storage
      prefs.setString("svg_list", jsonEncode(svgList));
      return true;
    } catch (e) {
      print("Error Occured While adding SVG :$e");
      return false;
    }
  }

  Future<List> getSVGListasStringFromLocalStorage() async {
    try {
      SharedPreferences prefs = await getSharedInstance();
      String? svgList = prefs.getString(listKey);
      if (svgList != null) {
        List decodedSVGList = jsonDecode(svgList).toList();
        return decodedSVGList;
      } else {
        return [];
      }
    } catch (e) {
      print(
          "Error occured while fetching SVGListAsSTring from localstorage :$e");
      return [];
    }
  }

  // Fetch the entire list of SVGs as a AssetModel
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

  Future<bool> updateSVGAssetModelByKey(AssetInfoModel currentModel) async {
    try {
      SharedPreferences prefs = await getSharedInstance();
      //   check if svg exists in the svgList
      List svgList = await getSVGListasStringFromLocalStorage();
      if (svgList.isNotEmpty && svgList.contains(currentModel.assetName)) {
        prefs.setString(
            currentModel.assetName, jsonEncode(currentModel.toJson()));
        return true;
      } else {
        throw Exception("SVGList Came Empty from localStorage");
      }
    } catch (e) {
      print("Error occured while updating : $e");
      return false;
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
      //   checking if the svg file name exists in svg file
      List svgList = await getSVGListasStringFromLocalStorage();
      //   removing the svgKey from svgList
      bool isStringRemoved = svgList.remove(svgKey);
      // updating the svgList
      if (isStringRemoved) {
        await prefs.setString(listKey, jsonEncode(svgList));
      }
      bool isSVGAssetRemoved = await prefs.remove(svgKey);
      if (isStringRemoved && isSVGAssetRemoved) {
        return true;
      } else {
        throw Exception("Something happened while removing svg Key");
      }
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
