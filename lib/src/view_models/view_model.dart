import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'package:vscout/database.dart';
import 'package:vscout/transfer.dart';

abstract class ViewModel {
  DatabaseHandler databaseHandler;
  Response result = Response();
  StreamController<Request> inputController = StreamController();
  StreamController outputController = StreamController();

  handleInputData(data) {}

  ViewModel() {
    this.databaseHandler = DatabaseHandler();
    this.inputController.stream.listen((data) => this.handleInputData(data));
    //TODO: Add pause() and resume() functions.
  }
}
