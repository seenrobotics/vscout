import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../utils/utils.dart';
import '../database/database.dart';
import '../response/response.dart';
import 'dart:async';
import 'package:vscout_cli/src/request/request.dart';

abstract class Model {
  DatabaseHandler databaseHandler;
  Response result = Response();
  StreamController<Request> inputController = StreamController();
  StreamController outputController = StreamController();

  handleInputData(data) {}

  Model() {
    this.databaseHandler = DatabaseHandler();
    this.inputController.stream.listen((data) => this.handleInputData(data));
    // this.inputController.stream.listen((data) async{
    //   this.outputController.add(await this.handleInputData(data));
    //   });
    //TODO: Add pause() and resume() functions.
  }
}
