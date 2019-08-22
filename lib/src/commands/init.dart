import 'package:args/command_runner.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:vscout_cli/src/view/view.dart';
import 'dart:async';


class InitCommand extends Command {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize database';

  
  StreamSubscription interruptSubscription;
  int initStage = 0;
  CliView cliView;  
  String relativeConfigFilePath = "/../config.yaml";
  String absoluteConfigFilePath;
  InitCommand(){
    this.cliView = CliView();
  }




  @override
  run() async {
        
    this.absoluteConfigFilePath = 
    ("${dirname(Platform.script.toFilePath()).toString()}${this.relativeConfigFilePath}");
    ///Intializes vscout-cli on first run.
    File configFile = new File(this.absoluteConfigFilePath);
    if(await configFile.exists()){
      print("Error! [${this.absoluteConfigFilePath}] already exists. Try running [vscout-exec config] instead.");
      return false;
    }
    else {
      configFile = await configFile.create();
      var writeSink = configFile.openWrite();
      writeSink.write("""
name: vscout_config
description: config settings for vscout
""");

      interruptSubscription = await this.cliView.requestInterrupt(this.name);

      interruptSubscription.onData((data) async {
        if(this.initStage ==0){
          String relativeDatabasePath;

          if(data[0].isEmpty){
            // Database defaults to this location.
            relativeDatabasePath = '/../database/vscout.db';
          }else {
          relativeDatabasePath = data[0];
          }
        //TODO: Create database at location.
        writeSink.write("database_path : $relativeDatabasePath\n");

        print("Database created at $relativeDatabasePath\nPlease enter main database store name: [vscout_main by default]");
        this.initStage++;
        } else if(this.initStage ==1) {
          String mainStoreName;
          if(data[0].isEmpty){
            mainStoreName = 'vscout_main';
          } else{
            mainStoreName = data[0];
          }
        writeSink.write("database_path : $mainStoreName\n");
        print("Main store set to $mainStoreName\n");
        this.cliView.concludeInterrupt(this.name);
        }
      });
    }
  }
}
