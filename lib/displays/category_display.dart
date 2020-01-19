//import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_explorer/displays/docs_display.dart';
import 'package:file_explorer/displays/images_display.dart';
import 'package:file_explorer/displays/audios_display.dart';
import 'package:file_explorer/displays/video_display.dart';
import 'package:file_explorer/notifiers/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pathlib;

class CategoryWise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     var coreNotifier = Provider.of<CoreNotifier>(context, listen: false);
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Browse Category Wise",
            ),
            backgroundColor: Colors.blueGrey,
            leading: BackButton(onPressed: () {
              if (coreNotifier.currentPath.absolute.path == pathlib.separator) {
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              } else {
                coreNotifier.navigateBackdward();
              }
            }),
          ),
          
          // body: ListView(
          //   children: [
          //     _tile('Images', '', 'assets/imgicon.png'),
          //     _tile('Audios', '', 'assets/musicicon.png'),
          //     _tile('Videos', '', 'assets/videoicon.png'),
          //     _tile('Documents', '', 'assets/docicon.png'),
          //   ],
          // )
          body: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/imgicon.png'),
                    title: Text('Images'),
                    dense: false,
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder : (context)=> ImageDisplayScreen(path: '/storage/emulated/0/')));
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: Image.asset('assets/musicicon.png'),
                    title: Text('Audios'),
                    dense: false,
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder : (context)=> AudioDisplayScreen(path: '/storage/emulated/0/')));
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: Image.asset('assets/docicon.png'),
                    title: Text('Documents'),
                    dense: false,
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder : (context)=> DocsDisplayScreen(path: '/storage/emulated/0/')));
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: Image.asset('assets/videoicon.png'),
                    title: Text('Videos'),
                    dense: false,
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder : (context)=> VIdeoDisplayScreen(path: '/storage/emulated/0/')));
                    },
                  ),
                ),

              ],
            ),
          ),
    );
  }
}

// ListTile _tile(String title, String subtitle, String a) => ListTile(
//       title: Text(title,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//           )),
//       subtitle: Text(subtitle),
//       leading: Image.asset(
//         a,
//         width: 50,
//         height: 50,
//       ),
//     );
