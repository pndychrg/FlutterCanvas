import 'dart:ui';

class AssetInfoModel {
  // Specific to WEB
  // assetLocation is nullable as asset is fetched from localStorage, so path is not required for web
  String? assetLocation;
  double dX, dY;
  double? mirrorDX;
  double assetHeightRespToBox;
  String? svgDataString;
  String assetName;
  Color color;
  bool isMirror = false;
  AssetInfoModel({
    this.assetLocation,
    required this.assetHeightRespToBox,
    required this.dY,
    required this.dX,
    required this.mirrorDX,
    required this.svgDataString,
    required this.assetName,
    required this.color,
    required this.isMirror,
  });
  // Helper function to convert Color to Hex string
  static String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  // Helper function to convert Hex string to Color
  static Color hexStringToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

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
        assetName: json['assetName'],
        // svgDataString: utf8.decode(
        //   base64Decode(json['svgDataString']!),
        // ),
        svgDataString: json['svgDataString'],
        color: hexStringToColor(json['color'] ?? '#FFFFFFFF'),
        isMirror: bool.parse(json['isMirror']) // Default to white if missing
        );
  }

  Map<String, String> toJson() {
    return {
      'assetLocation': assetLocation ?? 'none',
      'dX': dX.toString(),
      'dY': dY.toString(),
      'mirrorDX': mirrorDX.toString(),
      'assetHeightRespToBox': assetHeightRespToBox.toString(),
      'svgDataString': svgDataString.toString(),
      'assetName': assetName,
      'color': colorToHexString(color),
      'isMirror': isMirror.toString(), // Save color as hex string
    };
  }
}
