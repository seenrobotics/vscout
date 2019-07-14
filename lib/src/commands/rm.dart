import 'package:args/command_runner.dart';

import 'rm/type.dart';

class RmCommand extends Command {
  @override
  String get name => 'rm';

  @override
  String get description => 'Remove data or data types from the database';

  RmCommand() {
    addSubcommand(TypeCommand());
  }
  @override
  run() async {}
}
