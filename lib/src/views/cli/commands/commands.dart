library vscout_cli.commands;

import 'package:args/command_runner.dart';

import 'exit.dart';
import 'add.dart';
import 'find.dart';
import 'config.dart';
import 'init.dart';
import 'ls.dart';
import 'rm.dart';
import 'show.dart';
import 'update.dart';

export 'add.dart';
export 'find.dart';
export 'config.dart';
export 'init.dart';
export 'ls.dart';
export 'rm.dart';
export 'show.dart';
export 'update.dart';

class VscoutDataCommand extends Command {
  @override
  String get name => 'vscout';

  @override
  String get description => '';

  VscoutDataCommand() {
    addSubcommand(AddCommand());
    addSubcommand(FindCommand());
    addSubcommand(LsCommand());
    addSubcommand(RmCommand());
    addSubcommand(ShowCommand());
    addSubcommand(UpdateCommand());
  }

  @override
  run() async {}
}

class VscoutExecCommand extends Command {
  @override
  String get name => 'vscout-exec';

  @override
  String get description => '';

  VscoutExecCommand() {
    addSubcommand(InitCommand());
    addSubcommand(ConfigCommand());
    addSubcommand(ExitCommand());
  }
  @override
  run() async {}
}
