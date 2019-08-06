import '../database/database.dart';

class Model {
  DatabaseHandler databaseHandler;
  Map result;
  Model() {
    this.databaseHandler = new DatabaseHandler();
    this.result = new Map();
  }
}
