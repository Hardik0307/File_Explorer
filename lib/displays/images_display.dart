// framework
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

// packages
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pathlib;

// app files
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/views/popup_menu.dart';
import 'package:file_explorer/views/search.dart';
import 'package:file_explorer/notifiers/preferences.dart';
import 'package:file_explorer/views/file.dart';
import 'package:file_explorer/models/file.dart';
import 'package:file_explorer/utilities/dir_utils.dart' as filesystem;
import 'package:file_explorer/views/file_folder_dialog.dart';

class ImageDisplayScreen extends StatefulWidget {
  final String path;
  final bool home;
  const ImageDisplayScreen({@required this.path, this.home: false})
      : assert(path != null);
  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final preferences = Provider.of<PreferencesNotifier>(context);
    var coreNotifier = Provider.of<CoreNotifier>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Images",
              //coreNotifier.currentPath.absolute.path,
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
                            String s = mime(snapshot.data[index].path);
                            if (snapshot.data[index] is MyFile &&
                                snapshot.data[index].name != null &&
                                s != null &&
                                (s == 'image/bmp	' ||
                                    s == 'image/cis-cod' ||
                                    s == 'image/jpeg' ||
                                    s == 'image/tiff' ||
                                    s == 'image/gif' ||
                                    s == 'image/ief' ||
                                    s == 'image/png')) {
                              //print(s);

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
