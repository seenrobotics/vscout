import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

class DatabaseInit extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Find data to the database';

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  void handleResponse(data) {}

  @override
  run() async {}
}
