import 'package:file_explorer/views/folder.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

// packages
import 'package:provider/provider.dart';

// app files
import 'package:file_explorer/notifiers/core.dart';
import 'package:file_explorer/displays/folder_display.dart';
import 'package:file_explorer/models/file.dart';
import 'package:file_explorer/models/folder.dart';
import 'package:file_explorer/utilities/dir_utils.dart' as filesystem;

class Search extends SearchDelegate<String> {
  final String path;
  Search({this.path});

  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // clearing query
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<CoreNotifier>(
        builder: (context, model, child) => FutureBuilder(
              future: filesystem.search(path, query,
                  recursive: true), //	a	Stream<int>	or	null
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) return Text('Error:	${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Select	lot');
                  case ConnectionState.waiting:
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          CircularProgressIndicator(),
                          Text('Searching...')
                        ]));
                  case ConnectionState.active:
                    return Text('${snapshot.data}');
                  case ConnectionState.done:
                    return Results(
                      results: snapshot.data,
                    );
                }
                return null;
              },
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<CoreNotifier>(
        builder: (context, model, child) => FutureBuilder(
              future: filesystem.search(path, query,
                  recursive: true), //	a	Stream<int>	or	null
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) return Text('Error:	${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Select	lot');
                  case ConnectionState.waiting:
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          CircularProgressIndicator(),
                          Text('Search ..')
                        ]));
                  case ConnectionState.active:
                    return Text('${snapshot.data}');
                  case ConnectionState.done:
                    return Results(
                      results: snapshot.data,
                    );
                }
                return null;
              },
            ));
  }
}

class Results extends StatelessWidget {
  const Results({
    Key key,
    @required this.results,
  }) : super(key: key);

  final List<dynamic> results;

  @override
  Widget build(BuildContext context) {
    //var coreNotifier = Provider.of<CoreNotifier>(context, listen: false);
    return ListView.builder(
      itemCount: results.length,
      
      addAutomaticKeepAlives: true,
      key: key,
      itemBuilder: (context, index) {
        if (results[index] is MyFolder) {
          var x = results.length;
          print('Total Folders and files : ${x}');
          return ListTile(
            leading: Icon(Icons.folder),
            title: Text(results[index].name),
            onTap: () {     
               /*Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => FolderListScreen(
                             path: results[index].path,
                         )));
            coreNotifier.navigateToDirectory(results[index].path);
           */
            print("Click on Searched folder");
            print(results[index].path);
            return FolderWidget(
                                  path: results[index].path,
                                  name: results[index].name);
           },
          );
        } else if (results[index] is MyFile) {
          return ListTile(
            leading: Icon(Icons.image),
            title: Text(results[index].name),
            onTap: () {
              OpenFile.open(results[index].path);
            },
          );
        } else
          return ListTile(
            leading: Icon(Icons.image),
            title: Text(results[index].name),
            onTap: () {
              OpenFile.open(results[index].path);
            },
          );
      },
    );
  }
}
