import 'package:args/command_runner.dart';

import 'rm/attribute.dart';
import 'rm/data.dart';

class RmCommand extends Command {
  @override
  String get name => 'rm';

  @override
  String get description => 'Remove data or attributes from the database';

  RmCommand() {
    addSubcommand(AttributeCommand());
    addSubcommand(DataCommand());

  }
  @override
  run() async {}
}
