import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../utils/utils.dart';
import '../database/database.dart';
import '../response/response.dart';
import 'dart:async';

abstract class Model {
  DatabaseHandler databaseHandler;
  Response result = Response();
  StreamController<Map> inputController = StreamController();
  StreamController outputController = StreamController();

  void handleInputData(data){}

  Model() {
    this.databaseHandler = DatabaseHandler();
    this.inputController.stream.listen((data) => this.handleInputData(data));
    //TODO: Add pause() and resume() functions.
  }
}
