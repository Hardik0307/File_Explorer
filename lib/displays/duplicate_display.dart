// framework
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

// packages
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pathlib;
import 'package:mime_type/mime_type.dart';

// app files
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/views/popup_menu.dart';
import 'package:file_explorer/views/search.dart';
import 'package:file_explorer/notifiers/preferences.dart';
import 'package:file_explorer/views/file.dart';
import 'package:file_explorer/models/file.dart';
import 'package:file_explorer/utilities/dir_utils.dart' as filesystem;
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

class _DuplicateFileDisplayScreenState extends State<DuplicateFileDisplayScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  var list_file = new List<Future>();
  _DuplicateFileDisplayScreenState() {}
  @override
  

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String path = null;

  bool calculateMD5SumAsyncWithPlugin(String filePath, String filePath1) {
    Future<String> ret;
    Future<String> ret1;
    String x;
    String y;

    ret =  Md5Plugin.getMD5WithPath(filePath);
    ret.then((val) {
      print(val);
      x = val;
    });

    ret1 = Md5Plugin.getMD5WithPath(filePath1);
    ret1.then((val) {
      print(val);
      y = val;
    });

    if (x == y)
      return true;
    else
      return false;
  
  }

  List<ListView> la;
  

  Future convertToLists(List<MyFile> ls) async {
    var d = new List<MyFile>();
    Future<MyFile> m;
    for (int k = 0; k < ls.length; k++) {
      if (ls[k] is MyFile && mime(ls[k].path) != null) {
        var list = new List<MyFile>();
        var list2 = new List<String>();

        list.add(ls[k]);
        list2.add(ls[k].name);

        for (int i = k + 1; i < ls.length; i++) {
          int x = 1, y = 2;
          String x1 = "a", y1 = "b";
          bool exists1 = Directory(ls[k].path).existsSync();
          bool exists2 = Directory(ls[i].path).existsSync();

          if (mime(ls[k].path) != null && exists1 == false) {
            var file = File(ls[k].path);
            x = file.lengthSync();
            x1 = mime(ls[k].path);
          }
          if (mime(ls[i].path) != null && exists2 == false) {
            var file1 = File(ls[i].path);
            y = file1.lengthSync();
            y1 = mime(ls[i].path);
          }
          if ((x == y) &&
              (x1 == y1) &&
               calculateMD5SumAsyncWithPlugin(
                  ls[k].path, ls[i].path)) //)
          {
            
              
              list.add(ls[i]);
            list2.add(ls[i].name);
            d.add(ls[i]);
            
            ls.removeAt(i);
           
          }
        }

        if (list.length >= 2) {
         
            d.add(list[0]);
        
        }
      }
    }
 
    return d;
  }

  void initState() {
    _scrollController = ScrollController(keepScrollOffset: true);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        super.build(context);
    final preferences = Provider.of<PreferencesNotifier>(context);
    var coreNotifier = Provider.of<CoreNotifier>(context);
    //var list1 = new List<String>();

    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Duplicate Files",
              style: TextStyle(fontSize: 14.0),
              maxLines: 3,
            ),
          
            actions: <Widget>[
              IconButton(
                // Go home
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                },
                icon: Icon(Icons.home),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => showSearch(
                    context: context, delegate: Search(path: widget.path)),
              ),
              AppBarPopupMenu(path: widget.path)
            ]),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(milliseconds: 100))
                .then((_) => setState(() {}));
          },
          child: Consumer<CoreNotifier>(
            builder: (context, model, child) => FutureBuilder<List<dynamic>>(
              // This function Invoked every time user go back to the previous directory
              future: filesystem.searchFiles(
                  model.currentPath.absolute.path, '',
                  recursive: true),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data.length != 0) {
                      
                      return new Container(

                        child: FutureBuilder(
                          future:convertToLists(snapshot.data) ,
                          builder: (BuildContext context, AsyncSnapshot snapshot1) {
                            return ListView.builder(
                              itemCount: snapshot1.data.length,
                              itemBuilder: (context, index){
                                return Card(
                                 child:ListTile(
                                  leading:Image.asset('assets/fileicon1.png'),
                                  title: Text(snapshot1.data[index].name),
                                onTap: () {
                                  _printFuture(
                                      OpenFile.open(snapshot1.data[index].path));
                                },
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => FileContextDialog(
                                            path: snapshot1.data[index].path,
                                            name: snapshot1.data[index].name,
                                          ));
                                },
                              ));
                              },
                            );
                             
                          },
                        )                       
                        
                        
                        
                        /* ListView.builder(
                            itemCount: d.length,
                            itemBuilder: (context, index) {
                             /* return Card (
                                child:ListTile(
                                leading:Image(image:AssetImage('assets/fileicon1.png')),
                                title: Text(l[index].name),
                                 onTap: () {
                                  _printFuture(
                                      OpenFile.open(snapshot.data[index].path));
                                },
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => FileContextDialog(
                                            path:d[index].path,
                                            name:d[index].name,
                                          ));
                                })
                              );*/
                              
                            }),*/
                      );
                    } else {
                      return Center(
                        child: Text("Empty Directory!"),
                      );
                    }
                }
                return null; // unreachable
              },
            ),
          ),
        ),

        // check if the in app floating action button is activated in settings
        floatingActionButton: StreamBuilder<bool>(
          stream: preferences.showFloatingButton, //	a	Stream<int>	or	null
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) return Text('Error:	${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Select	lot');
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.active:
                return FolderFloatingActionButton(
                  enabled: snapshot.data,
                  path: widget.path,
                );
              case ConnectionState.done:
                FolderFloatingActionButton(enabled: snapshot.data);
            }
            return null;
          },
        ));
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
