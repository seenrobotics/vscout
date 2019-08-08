import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../utils/utils.dart';
import '../database/database.dart';
import '../response/response.dart';

abstract class Model {
  DatabaseHandler databaseHandler;
  Response result = Response();
  Model() {
    this.databaseHandler = DatabaseHandler();
  }
}
