import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../utils/utils.dart';
import '../database/database.dart';

abstract class Model {
  DatabaseHandler databaseHandler;
  Map result = Map();
  Model() {
    this.databaseHandler = DatabaseHandler();
  }
}
