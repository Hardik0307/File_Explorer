// framework
import 'package:flutter/material.dart';

// packages
import 'package:provider/provider.dart';

// app files
import 'package:file_explorer/displays/about.dart';
import 'package:file_explorer/displays/settings.dart';
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/views/create_folder_dialog.dart';

class AppBarPopupMenu extends StatelessWidget {
  final String path;
  const AppBarPopupMenu({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("AppBarPopupMenu(path): $path");
    return Consumer<CoreNotifier>(
      builder: (context, model, child) => PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "refresh") {
              model.reload();
            } else if (value == "folder") {
              showDialog(
                  context: context,
                  builder: (context) => CreateFolderDialog(path: path));
            } 
             else if (value == "settings") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            } else if (value == "about") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutScreen()));
            }
            //...
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                

                const PopupMenuItem<String>(
                    value: 'refresh', child: Text('Refresh')),
                const PopupMenuItem<String>(
                    value: 'folder', child: Text('New Folder')),
                // const PopupMenuItem<String>(
                //     value: 'category', child: Text('Show Category Wise')),
                const PopupMenuItem<String>(
                    value: 'settings', child: Text('Settings')),
                const PopupMenuItem<String>(
                    value: 'about', child: Text('About')),
                //...
              ]),
    );
  }
}
