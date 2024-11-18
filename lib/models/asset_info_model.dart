import 'dart:convert';

class AssetInfoModel {
  // Specific to WEB
  // assetLocation is nullable as asset is fetched from localStorage, so path is not required for web
  String? assetLocation;
  double dX, dY;
  double? mirrorDX;
  double assetHeightRespToBox;
  String? svgDataString;

  AssetInfoModel({
    this.assetLocation,
    required this.assetHeightRespToBox,
    required this.dY,
    required this.dX,
    required this.mirrorDX,
    required this.svgDataString,
  });

  factory AssetInfoModel.fromJson(Map<String, dynamic> json) {
    // every thing is forced to not be null, so take care if any null values are provided
    // all null checks should be performed before running this function
    // as it is a factory function so null checks can't be performed here
    return AssetInfoModel(
        assetLocation: json['assetLocation']!,
        assetHeightRespToBox: double.parse(json['assetHeightRespToBox']!),
        dX: double.parse(json['dX']!),
        dY: double.parse(json['dY']!),
        mirrorDX: double.parse(json['mirrorDX']!),
        // svgDataString: utf8.decode(
        //   base64Decode(json['svgDataString']!),
        // ),
        svgDataString: json['svgDataString']);
  }

  Map<String, String> toJson() {
    return {
      'assetLocation': assetLocation ?? 'none',
      'dX': dX.toString(),
      'dY': dY.toString(),
      'mirrorDX': mirrorDX.toString(),
      'assetHeightRespToBox': assetHeightRespToBox.toString(),
      'svgDataString': svgDataString.toString(),
    };
  }
}
