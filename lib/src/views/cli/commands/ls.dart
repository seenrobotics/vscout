import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'ls/attribute.dart';
import 'ls/data.dart';
import 'ls/file.dart';

class LsCommand extends Command {
  @override
  String get name => 'ls';

  @override
  String get description => 'List';

  LsCommand() {
    addSubcommand(AttributeCommand());
    addSubcommand(DataCommand());
    addSubcommand(FileCommand());
  }
  @override
  run() async {}
}
