// framework
import 'package:flutter/material.dart';

// app
import 'package:file_explorer/views/file_folder_dialog.dart';
import 'package:file_explorer/notifiers/core.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatelessWidget {
  final String path;
  final String name;

  const FolderWidget({@required this.path, @required this.name});
  @override
  Widget build(BuildContext context) {
    var coreNotifier = Provider.of<CoreNotifier>(context, listen: false);
    return Container(
        child: InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        print("Click on folder");
        print(path);
        coreNotifier.navigateToDirectory(path);
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => FolderContextDialog(
                  path: path,
                  name: name,
                ));
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image.asset(
          "assets/foldericon1.png",
          width: 50,
          height: 50,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 11.5),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
      ]),
    ));
  }
}
