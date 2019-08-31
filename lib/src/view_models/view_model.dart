import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../src/utils/utils.dart';

import 'package:path/path.dart';

import '../../src/database/filterHandler.dart';

import 'package:vscout/database.dart';
import 'package:vscout/transfer.dart';

abstract class ViewModel {
  MainDatabaseHandler databaseHandler;
  Response result = Response();
  StreamController<Request> inputController = StreamController();
  StreamController outputController = StreamController();
  FilterHandler queryDBHandler = FilterHandler();

  handleInputData(Request data);

  ViewModel() {
    this.databaseHandler = MainDatabaseHandler();
    this.inputController.stream.listen((data) async {
      // Request request = await this.queryDBHandler.handleRequest(data);
      this.handleInputData(data);
    });
    //TODO: Add pause() and resume() functions.
  }
}
