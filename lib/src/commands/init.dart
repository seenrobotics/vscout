import 'package:args/command_runner.dart';

class InitCommand extends Command {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize database';

  InitCommand();
  @override
  run() async {}
}
