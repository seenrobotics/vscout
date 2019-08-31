import 'dart:convert';

import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;
import 'dart:io';
import 'package:path/path.dart';
import 'package:vscout/src/views/cli/view.dart';
import 'dart:async';
import 'package:safe_config/safe_config.dart';
import 'dart:mirrors';
import 'package:yaml/yaml.dart';
import 'package:vscout/src/database/mainDatabaseHandler.dart';

class UserQuery {
  String queryTitle;
  var queryContent;
  var queryDefault;
  IOSink writeSink;
  UserQuery(String title, var queryDefault, IOSink writeSink) {
    this.queryTitle = title;
    this.queryDefault = queryDefault;
    this.writeSink = writeSink;
  }
  askQuery() async {
    print("Please enter $queryTitle, $queryDefault by default");
  }

  Future handleQuery(var data) async {
    queryContent = (data.isNotEmpty) ? data : queryDefault;
    this.writeSink.write("$queryTitle: $queryContent\n");
    print("$queryTitle set to $queryContent");
    return queryContent;
  }
}

class InitCommand extends Command {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize database';

  StreamSubscription interruptSubscription;
  int initStage = 0;
  CliView cliView;
  String relativeConfigFilePath = "/../config.yaml";
  String absoluteConfigFilePath;
  InitCommand() {
    this.cliView = CliView();
  }

  @override
  run() async {
    this.absoluteConfigFilePath =
        ("${dirname(Platform.script.toFilePath()).toString()}${this.relativeConfigFilePath}");

    ///Intializes vscout-cli on first run.
    File configFile = File(this.absoluteConfigFilePath);
    //TODO: make this read as a stream of lines
    var config = loadYaml(configFile.readAsStringSync());
    //Create datbase if it doesn't exist
    File databaseFile = File(config["database_location"]);
    if (!await databaseFile.exists()) {
      databaseFile.createSync();
    }

    //Start up database
    await MainDatabaseHandler().initializeDatabase(config["database_location"]);
    await MainDatabaseHandler().setStore(storeName: config["main_store"]);

    if (await configFile.exists()) {
      var config = new ApplicationConfiguration(this.absoluteConfigFilePath);
      print("${config.database_location}");
      print(
          "Error! [${this.absoluteConfigFilePath}] already exists. Try running [vscout-exec config] instead.");
      return false;
    } else {
      configFile = await configFile.create();
      var writeSink = configFile.openWrite();
      writeSink.write("""
name: vscout_config
description: config settings for vscout
""");
      UserQuery databaseLocationQuery =
          UserQuery("database_location", "/../database/vscout.db", writeSink);
      UserQuery mainStoreQuery =
          UserQuery("main_store", "vscout_main", writeSink);
      databaseLocationQuery.askQuery();
      interruptSubscription = await this.cliView.requestInterrupt(this.name);
      interruptSubscription.onData((data) async {
        if (this.initStage == 0) {
          String databaseLocation =
              await databaseLocationQuery.handleQuery(data[0]);
          File databaseFile = File(databaseLocation);
          if (!await databaseFile.exists()) {
            databaseFile.createSync();
          }
          //TODO: Create database at location.

          mainStoreQuery.askQuery();
          this.initStage++;
        } else if (this.initStage == 1) {
          String mainStoreName = await mainStoreQuery.handleQuery(data[0]);

          this.cliView.concludeInterrupt(this.name);
        }
      });
    }
  }
}

class ApplicationConfiguration extends Configuration {
  ApplicationConfiguration(String fileName) : super.fromFile(File(fileName));

  String database_location;
  String main_store;
  String name;
  String description;
}
