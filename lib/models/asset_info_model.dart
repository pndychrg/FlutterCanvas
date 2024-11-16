class AssetInfoModel{
  String assetLocation;
  double dX, dY;
  double? mirrorDX;
  double assetHeightRespToBox;

  AssetInfoModel({required this.assetLocation, required this.assetHeightRespToBox, required this.dY, required this.dX, this.mirrorDX});
}