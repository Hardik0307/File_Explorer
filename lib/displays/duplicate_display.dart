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
  void initState() {
    _scrollController = ScrollController(keepScrollOffset: true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



bool calculateMD5SumAsyncWithPlugin(String filePath, String filePath1) {
    Future<String> ret;
    Future<String> ret1;
    String x;
    String y;
  
        ret = Md5Plugin.getMD5WithPath(filePath);
        ret.then((val){
          print(val);
          x = val;
        });
     
        ret1 = Md5Plugin.getMD5WithPath(filePath1);
        ret1.then((val){
          print(val);
          y = val;
        });
   
    if(x == y) 
      return true;
    else
      return false;
    //return ret;
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final preferences = Provider.of<PreferencesNotifier>(context);
    var coreNotifier = Provider.of<CoreNotifier>(context);
    var list1 = new List<String>();

    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Duplicate Files",
              style: TextStyle(fontSize: 14.0),
              maxLines: 3,
            ),
            leading: BackButton(onPressed: () {
              if (coreNotifier.currentPath.absolute.path == pathlib.separator) {
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              } else {
                coreNotifier.navigateBackdward();
              }
            }),
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
              builder: (BuildContext context, AsyncSnapshot snapshot)  {
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
                     
                      return GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          key: PageStorageKey(widget.path),
                          padding:
                              EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            
                            String s;
                            if (snapshot.data[index] is MyFile &&
                                mime(snapshot.data[index].path) != null) {
                              var list = new List<MyFile>();
                              var list2 = new List<String>();
                              list.add(snapshot.data[index]);
                              list2.add(snapshot.data[index].name);

                             
                               for (int i = index + 1;
                                   i < snapshot.data.length;
                                   i++) {
                              int x=1,y=2;
                              String x1="a",y1="b";
                              bool exists1 = Directory(snapshot.data[index].path).existsSync();
                              bool exists2 = Directory(snapshot.data[i].path).existsSync();
                             
                              if(mime(snapshot.data[index].path) != null &&  exists1 == false)
                              {
                                var file = File(snapshot.data[index].path);
                                x = file.lengthSync();
                                x1 = mime(snapshot.data[index].path); 
                              }
                              if(mime(snapshot.data[i].path) != null && exists2 == false)
                              {
                                var file1 = File(snapshot.data[i].path);
                                 y = file1.lengthSync() ;
                                y1 = mime(snapshot.data[i].path);
                              }
                              if ((x == y) && (x1== y1) && calculateMD5SumAsyncWithPlugin(snapshot.data[index].path,snapshot.data[i].path))// == snapshot.data[i].name)
                               {
                                  list.add(snapshot.data[i]);
                                  list2.add(snapshot.data[i].name);
                                  snapshot.data.removeAt(i);
                                
                                }
                               }

                              if (list.length >= 2) {
                                print(list2);
                                for (int j = 0; j < list.length; j++) {
                                  
                                  return FileWidget(
                                    name: list[j].name,
                                    onTap: () {
                                      _printFuture(OpenFile.open(list[j].path));
                                    },
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              FileContextDialog(
                                                path: list[j].path,
                                                name: list[j].name,
                                              ));
                                    },
                                  );
                                }
                              }
                            }
                            return Container();
                          });
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
