library vscout_cli.tool;

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import 'package:vscout_cli/vscout_cli.dart';

main(List<String> args) async {
  var runner = CommandRunner(
      'vscout',
      'Robotics scouting software'
          '\n\n'
          'https://vscout.readthedocs.io');

  runner.argParser.addFlag('verbose', negatable: false);

  runner..addCommand(AddCommand());

  return await runner.run(args).catchError((exception, stackTrace) {
    if (exception is String) {
      stdout.writeln(exception);
    } else {
      stderr.writeln('Error Message: $exception');
      if (args.contains('--verbose')) {
        stderr.writeln(stackTrace);
      }
    }
    exitCode = 1;
  }).whenComplete(() {
    stdout.write(resetAll.wrap(''));
  });
}
