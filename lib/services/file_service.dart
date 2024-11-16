// all of this code is going to be for web only
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FileService {
  final String LIST_KEY = 'svg_list';

  Future getSharedInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<bool> saveSVGToLocalStorage(String key, String value) async {
    try {
      SharedPreferences prefs = await getSharedInstance();

      //   Retrieve the current list of SVGS as a map
      String? existingData = prefs.getString(LIST_KEY);
      Map<String, String> svgMap = existingData != null
          ? Map<String, String>.from(jsonDecode(existingData))
          : {};
      //   Add or update the SVG in the map
      print(svgMap.keys.toString());
      svgMap[key] = value;
      //    Save the updated Map back to local Storage
      prefs.setString("svg_list", jsonEncode(svgMap));
      return true;
    } catch (e) {
      print("Error occured : $e");
      return false;
    }
  }

  // Fetch the entire list of SVGs as a map
  Future<Map<String, String>> getSVGListFromLocalStorage() async {
    try {
      SharedPreferences prefs = await getSharedInstance();

      // Retrieve the SVG map
      String? existingData = prefs.getString(LIST_KEY);
      if (existingData != null) {
        return Map<String, String>.from(jsonDecode(existingData));
      } else {
        return {};
      }
    } catch (e) {
      print("Error retrieving SVG list: $e");
      return {};
    }
  }

  //   Fetch a single SVG by it's key
  Future<String?> getSvgByKey(String svgKey) async {
    try {
      SharedPreferences prefs = await getSharedInstance();

      // Retrieve the SVG map
      String? existingData = prefs.getString(LIST_KEY);
      if (existingData != null) {
        Map<String, String> svgMap =
            Map<String, String>.from(jsonDecode(existingData));
        return svgMap[svgKey];
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
      String? existingData = prefs.getString(LIST_KEY);
      if (existingData != null) {
        Map<String, String> svgMap =
            Map<String, String>.from(jsonDecode(existingData));
        svgMap.remove(svgKey);

        // Save the updated map back to local storage
        prefs.setString(LIST_KEY, jsonEncode(svgMap));
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
      return await prefs.remove(LIST_KEY);
    } catch (e) {
      print("Error clearing SVG list: $e");
      return false;
    }
  }
}
