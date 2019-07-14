import 'package:args/command_runner.dart';

class LsCommand extends Command {
  @override
  String get name => 'ls';

  @override
  String get description => 'List';

  LsCommand();
  @override
  run() async {}
}
