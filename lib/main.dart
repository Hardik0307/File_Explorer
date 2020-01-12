import 'package:flutter/material.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Explorer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('File Explorer'),
        ),
        body: Center(
          child: Text('Work in Progress.......!'),
        ),
      ),
    );
  }
}

