import 'package:flutter/services.dart' show rootBundle;

final AssetManager assets = AssetManager();

class AssetManager {
  Future<String> loadTextAsset(String name) async {
    return await rootBundle.loadString(name);
  }
}
