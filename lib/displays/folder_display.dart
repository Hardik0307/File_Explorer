import 'package:file_explorer/views/create_folder_dialog.dart';
import 'package:flutter/material.dart';

// packages
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:file_explorer/displays/docs_display.dart';
import 'package:file_explorer/displays/images_display.dart';
import 'package:file_explorer/displays/audios_display.dart';
import 'package:file_explorer/displays/video_display.dart';
// app files
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/views/popup_menu.dart';
import 'package:file_explorer/views/search.dart';
import 'package:file_explorer/notifiers/preferences.dart';
import 'package:file_explorer/views/file.dart';
import 'package:file_explorer/models/file.dart';
import 'package:file_explorer/models/folder.dart';
import 'package:file_explorer/views/folder.dart';
import 'package:file_explorer/utilities/dir_utils.dart' as filesystem;
import 'package:file_explorer/views/file_folder_dialog.dart';

import 'duplicate_display.dart';

class FolderListScreen extends StatefulWidget {
  final String path;
  final bool home;
  const FolderListScreen({@required this.path, this.home: false})
      : assert(path != null);
  @override
  _FolderListScreenState createState() => _FolderListScreenState(path:this.path);
}

class _FolderListScreenState extends State<FolderListScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  @override
  void initState() {

    
    _scrollController = ScrollController(keepScrollOffset: true);
    super.initState();
  }
  String path;
  _FolderListScreenState({this.path});


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final preferences = Provider.of<PreferencesNotifier>(context);

    return Scaffold(
        drawer:this.path=='/storage/emulated/0/'? new Drawer(
            child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
             
              accountEmail:null,
              accountName: null,
            ),
            new ListTile(
              leading: Image.asset('assets/imgicon.png'),
              title: Text('Images'),
              dense: false,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ImageDisplayScreen(path: this.path)));
              },
            ),
            new ListTile(
              leading: Image.asset('assets/musicicon.png'),
              title: Text('Audios'),
              dense: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AudioDisplayScreen(path: this.path)));
              },
            ),
            new ListTile(
              leading: Image.asset('assets/docicon.png'),
              title: Text('Documents'),
              dense: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DocsDisplayScreen(path:this.path)));
              },
            ),
            new ListTile(
              leading: Image.asset('assets/videoicon.png'),
              title: Text('Videos'),
              dense: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VIdeoDisplayScreen(path:this.path)));
              },
            ),
            new ListTile(
              leading: Image.asset('assets/duplicateicon.png'),
              title: Text('Duplicate Files'),
              dense: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DuplicateFileDisplayScreen(
                            path:this.path)));
              },
            )
          ],
        )):null,
        appBar: AppBar(
            title:this.path.startsWith('/storage/emulated/0/')? Text(
              "Internal Storage",
              //coreNotifier.currentPath.absolute.path,
              style: TextStyle(fontSize: 14.0),
              maxLines: 3,
            ):Text("External Storage",style: TextStyle(fontSize: 14.0),
              maxLines: 3,),
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
              future: filesystem.getFoldersAndFiles(
                  model.currentPath.absolute.path,
                  keepHidden: preferences.hidden),
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
                            // folder
                            if (snapshot.data[index] is MyFolder) {
                              return FolderWidget(
                                  path: snapshot.data[index].path,
                                  name: snapshot.data[index].name);

                              // file
                            } else if (snapshot.data[index] is MyFile) {
                              return FileWidget(
                                name: snapshot.data[index].name,
                                onTap: () {
                                  _printFuture(
                                      OpenFile.open(snapshot.data[index].path));
                                },
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => FileContextDialog(
                                            path: snapshot.data[index].path,
                                            name: snapshot.data[index].name,
                                          ));
                                },
                              );
                            }
                            return Container();
                          });
                    } else {
                      return Center(
                        child: Text("empty directory!"),
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
    if (enabled == true) {
      return FloatingActionButton(
        tooltip: "Create Folder",
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Icon(Icons.add),
        onPressed: () => showDialog(
            context: context, builder: (context) => CreateFolderDialog()),
      );
    } else
      return Container(
        width: 0.0,
        height: 0.0,
      );
  }
}
