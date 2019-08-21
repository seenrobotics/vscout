import 'package:flutter/material.dart';
import './views/initial_profile_view.dart';
import './views/vscout_view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import './themes.dart';

void main() => runApp(Vscout());

class Vscout extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) =>
            build_light_theme().copyWith(brightness: brightness),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'vscout',
            theme: theme,
            darkTheme: build_dark_theme(),
            initialRoute: '/create_profile',
            routes: {
              '/': (context) => VscoutView(),
              '/create_profile': (context) => CreateProfileView(),
            },
          );
        });
  }
}
