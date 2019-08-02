import 'package:args/command_runner.dart';

import 'rm/attribute.dart';

class RmCommand extends Command {
  @override
  String get name => 'rm';

  @override
  String get description => 'Remove data or attributes from the database';

  RmCommand() {
    addSubcommand(AttributeCommand());
  }
  @override
  run() async {}
}
