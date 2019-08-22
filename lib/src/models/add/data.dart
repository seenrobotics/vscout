import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';

class AddDataModel extends Model {
  addStringData(String dataEntry) async {
    Map properties = parseArgsJson(dataEntry);
    await this.addMapData(properties);
    this.result.statusCheck(dataEntry, 'ADD/DATA/STRING');
    return this.result;
  }

  addMapData(Map dataEntry) async {
    this.result = await this.databaseHandler.addEntry(dataEntry);
    this.result.statusCheck(dataEntry.toString(), 'ADD/DATA/MAP');
    return this.result;
  }

  addFileData(String relativeFilePath) async {
    String fileFolder = '/../files/';
    //  Tries to find file in [files] folder.
    var absFilePath =
        ("${dirname(Platform.script.toFilePath()).toString()}$fileFolder$relativeFilePath");
    final inputFile = new File(absFilePath);
    String fileContents;
    fileContents = await inputFile.readAsString();
    //  Decode file contents as JSON.
    Map baseMap = json.decode(fileContents);
    // Remove trailing white space, convert inputs to string to allow for staticly typed Dart methods.
    Map properties = Map<String, String>();
    baseMap.forEach((k, v) =>
        properties[k is String ? k.trim() : k.toString().trim()] =
            v is String ? v.trim() : v.toString().trim());
    await this.addMapData(properties);
    this.result.statusCheck(relativeFilePath, 'ADD/DATA/FILE');
    return this.result;
  }
}
