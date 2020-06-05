// framework
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
// packages
import 'package:open_file/open_file.dart';
import 'package:mime_type/mime_type.dart';

// app files
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/models/file.dart';
import 'package:file_explorer/views/file_folder_dialog.dart';

import 'package:md5_plugin/md5_plugin.dart';

class DuplicateFileDisplayScreen extends StatefulWidget {
  final String path;
  final bool home;
  const DuplicateFileDisplayScreen({@required this.path, this.home: false})
      : assert(path != null);
  @override
  _DuplicateFileDisplayScreenState createState() =>
      _DuplicateFileDisplayScreenState();
}

class Duplicate {
  String hash;
  MyFile fileobject;
  Duplicate({this.hash, this.fileobject});
}

String getImage(String path) {
  String s = mime(path);
  // print(s);
  if (s == 'audio/mpeg' ||
      s == 'audio/basic' ||
      s == 'audio/mid	' ||
      s == 'audio/x-aiff' ||
      s == 'audio/ogg' ||
      s == 'audio/vnd.wav') {
    return 'assets/music1.jpeg';
  } else if (s == 'application/msword' ||
      s ==
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
      s == 'application/json' ||
      s == 'application/vnd.oasis.opendocument.text' ||
      s == 'application/vnd.oasis.opendocument.spreadsheet' ||
      s == 'application/vnd.oasis.opendocument.presentation' ||
      s == 'application/pdf' ||
      s == 'application/vnd.ms-powerpoint' ||
      s == 'application/x-rar-compressed ' ||
      s == 'application/x-tar' ||
      s == 'application/zip' ||
      s == 'application/x-7z-compressed') {
    return 'assets/doc.jpeg';
  } else if (s == 'video/mp4' ||
      s == 'video/x-flv' ||
      s == 'video/3gpp' ||
      s == 'video/x-msvideo' ||
      s == 'video/x-ms-wmv') {
    return 'assets/video.jpeg';
  } else if (s == 'image/bmp	' ||
      s == 'image/cis-cod' ||
      s == 'image/jpeg' ||
      s == 'image/tiff' ||
      s == 'image/gif' ||
      s == 'image/ief' ||
      s == 'image/png') {
    return 'assets/image.jpeg';
  } else {
    return 'assets/fileicon1.png';
  }
}

class _DuplicateFileDisplayScreenState extends State<DuplicateFileDisplayScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  var list_file = new List<Future>();
  _DuplicateFileDisplayScreenState() {}
  @override
  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  int flag = 0;
  List<ListView> la;
  List<MyFile> file;
  List<Duplicate> dup = new List();
  List<String> hash = new List();

  List<Duplicate> x = new List();
  Future<void> sortDuplicate() async {
    dup.sort((a, b) => (a.hash).compareTo(b.hash));
    for (int i = 0; i < dup.length - 1;) {
      flag = 0;
      int j;
      for (j = i + 1; j < dup.length; j++) {
        if ((dup[i].hash).compareTo(dup[j].hash) == 0) {
          if (mime(dup[i].fileobject.path) == mime(dup[j].fileobject.path)) {
            x.add(dup[j]);
            flag = 1;
          }
        } else {
          break;
        }
      }
      if (flag == 1) {
        x.add(dup[i]);
        x.add(new Duplicate(hash: null, fileobject: null));
      }
      i = j;
    }

    setState(() {
      flag = 1;
    });
  }

  Future<void> calculateMD5SumAsyncWithPlugin() async {
    for (int i = 0; i < file.length; i++) {
      String x = null;
      await Md5Plugin.getMD5WithPath(file[i].path).then((val) {
        dup.add(new Duplicate(hash: val, fileobject: file[i]));
        x = val;
      });
    }
    int x = 0;
    setState(() {
      x = 1;
    });
    dup.removeWhere((element) => element.hash == null);
    await sortDuplicate();
    print("Finish");
  }

  Future<void> calculateHash() async {
    Directory _path = Directory("/storage/emulated/0/");
    List<dynamic> _files1;
    try {
      _files1 = await _path.list(recursive: true).toList();
      _files1 = _files1.map((path) {
        return MyFile(
            name: p.split(path.absolute.path).last,
            path: path.absolute.path,
            type: "File");
      }).toList();
      _files1.removeWhere((test) {
        return test.name.startsWith('.') == true || mime(test.path) == null;
      });
    } on FileSystemException catch (e) {
      stdout.writeln(e);
    }

    file = _files1.cast<MyFile>();
    print(file.length);
    await calculateMD5SumAsyncWithPlugin();
  }

  void initState() {
    calculateHash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (file != null && flag == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Duplicate Files",
            style: TextStyle(fontSize: 14.0),
            maxLines: 3,
          ),
        ),
        body: ListView.builder(
          itemCount: x.length,
          itemBuilder: (context, index) {
            if (x[index].hash != null) {
              return Dismissible(
                background: new Container(color:Colors.red),
                key: UniqueKey(),
                onDismissed: (direction) {
                    String path=x[index].fileobject.path;
                    String name=x[index].fileobject.name;
                    CoreNotifier model=new CoreNotifier();
                  setState(() {
                    x.removeAt(index);
                    model.delete(path);
                    Scaffold.of(context).showSnackBar(new SnackBar(content: Text(
                      "${name}  Removed..."
                    ),
                    duration:Duration(seconds:1) ,
                    ),
                    );
                    });
                },
            child: ListTile(
                  leading: Image.asset(getImage(x[index].fileobject.path)),
                  title: Text(x[index].fileobject.name),
                  onTap: () {
                                  _printFuture(
                                        OpenFile.open(x[index].fileobject.path));
                                  },
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => FileContextDialog(
                                              path: x[index].fileobject.path,
                                              name: x[index].fileobject.path,
                                      ));
                                  },
                ),
              );
            } else {
              return Divider(
                color: Colors.black,
              );
            }
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Duplicate Files",
            style: TextStyle(fontSize: 14.0),
            maxLines: 3,
          ),
        ),
        body: Center(
            child: Text(
          "Loading...",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
_printFuture(Future<String> open) async {
  print("Opening: " + await open);
}
class FolderFloatingActionButton extends StatelessWidget {
  final bool enabled;
  final String path;
  const FolderFloatingActionButton({Key key, this.enabled, this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //folder creation
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}
