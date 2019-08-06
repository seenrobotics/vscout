import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../utils/utils.dart';
import '../database/database.dart';

class Model {
  DatabaseHandler databaseHandler;
  Map result;
  Model() {
    this.databaseHandler = DatabaseHandler();
  }
}
