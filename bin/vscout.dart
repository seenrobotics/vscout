library vscout.tool;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import 'package:vscout/src/views/cli/view.dart';
import 'package:vscout/src/views/cliLogo.dart' as logo;

import 'package:vscout/vscout_cli.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart';
import 'package:vscout/src/database/filterHandler.dart';
import 'package:yaml/yaml.dart';

import 'package:vscout/vscout_cli.dart';
import 'package:vscout/database.dart';

// The exit code for a general error.
String relativeConfigFilePath = "/../config.yaml";

main(List<String> args) async {
  logo.printLogo();
  String absoluteConfigFilePath =
      ("${dirname(Platform.script.toFilePath()).toString()}${relativeConfigFilePath}");
  File configFile = File(absoluteConfigFilePath);
  var config = loadYaml(configFile.readAsStringSync());

  List<dynamic> runCommands = List();
  // Create a new database handler with empty constructor.
  // Run all constructor functions in async function to await database construction completion.
  //  This is to prevent calls to an unfinished database object.
  // Add database related commands only if database exists, else only add [init] and [config].

  await MainDatabaseHandler().initializeDatabase(config["database_location"]);
  await MainDatabaseHandler().setStore(storeName: config["main_store"]);
  await FilterHandler().initializeDatabase(config["database_location"]);
  await FilterHandler().setStore();
  var runner = CommandRunner(
      'vscout',
      'Robotics scouting software'
          '\n\n'
          'https://vscout.readthedocs.io');

  runner.argParser.addFlag('verbose', negatable: false);
  runner..addCommand(VscoutDataCommand());
  runner..addCommand(VscoutExecCommand());
  CliView view = CliView();
  view.runner = runner;

  // Stream cmdLine = Utf8Decoder().bind(stdin).transform(InputArgsParser());
  // await view.listenTo(cmdLine);

  await view.listenTo(stdin);

  await view.inputSubscription.asFuture();
  print('vscout exited with code 0');
}
