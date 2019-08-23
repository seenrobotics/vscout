import 'package:args/command_runner.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:vscout_cli/src/view/view.dart';
import 'dart:async';
import 'package:vscout_cli/globals/globals.dart' as globals;

class UserQuery {
  String queryTitle;
  var queryContent;
  var queryDefault;
  IOSink writeSink;
  UserQuery(String title, var queryDefault, IOSink writeSink){
    this.queryTitle = title;
    this.queryDefault = queryDefault;
    this.writeSink = writeSink;

  }
  askQuery() async{
    print("Please enter $queryTitle, $queryDefault by default");
  }
  Future handleQuery(var data) async{
    queryContent = (data.isNotEmpty) ? data : queryDefault;
    this.writeSink.write("$queryTitle: $queryContent\n");
    print("$queryTitle set to $queryContent");
    return queryContent;
  }
}



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
      UserQuery databaseLocationQuery = UserQuery("Database_Location", "/../database/vscout.db", writeSink);
      UserQuery mainStoreQuery = UserQuery("Main_Store", "vscout_main", writeSink);
      databaseLocationQuery.askQuery();
      interruptSubscription = await this.cliView.requestInterrupt(this.name);
      interruptSubscription.onData((data) async {
        if(this.initStage ==0){
          String databaseLocation = await databaseLocationQuery.handleQuery(data[0]);

        //TODO: Create database at location.

        mainStoreQuery.askQuery();
        this.initStage++;
        } else if(this.initStage ==1) {
        String mainStoreName = await mainStoreQuery.handleQuery(data[0]);
        
        this.cliView.concludeInterrupt(this.name);
        }
      });
    }
  }
}

