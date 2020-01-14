// framework
import 'package:flutter/material.dart';

// app files
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/notifiers/preferences.dart';
import 'package:file_explorer/displays/home_display.dart';

// packages
import 'package:provider/provider.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

main() {
  runApp(MultiProvider(
    providers: [
      ValueListenableProvider(create: (context) => ValueNotifier(true)),
      ChangeNotifierProvider(create: (context) => CoreNotifier()),
      ChangeNotifierProvider(create: (context) => PreferencesNotifier()),
    ],
    child: MyApp(),
  ));
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.blueGrey,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          FlutterStatusbarcolor.setStatusBarColor(theme.primaryColor);
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            
            home: StorageScreen()
          );
        });
  }
}




