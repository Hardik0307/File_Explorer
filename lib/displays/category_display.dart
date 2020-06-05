import 'package:file_explorer/displays/docs_display.dart';
import 'package:file_explorer/displays/images_display.dart';
import 'package:file_explorer/displays/audios_display.dart';
import 'package:file_explorer/displays/video_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryWise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Browse Category Wise",
          ),
          backgroundColor: Colors.blueGrey,
          
        ),

        
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Image.asset('assets/imgicon.png'),
                title: Text('Images'),
                dense: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageDisplayScreen(
                              path: '/storage/emulated/0/')));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/musicicon.png'),
                title: Text('Audios'),
                dense: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AudioDisplayScreen(
                              path: '/storage/emulated/0/')));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/docicon.png'),
                title: Text('Documents'),
                dense: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DocsDisplayScreen(path: '/storage/emulated/0/')));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/videoicon.png'),
                title: Text('Videos'),
                dense: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VIdeoDisplayScreen(
                              path: '/storage/emulated/0/')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
