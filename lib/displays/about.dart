// framework
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          <Widget>[
        SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(),
            title: Container(child: Text('About')),
            forceElevated: innerBoxIsScrolled,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(25),
                child: TabBar(
                  tabs: <Tab>[
                    new Tab(
                      text: "Developers",
                    ),
                  ],
                  controller: _tabController,
                ))),
      ],
      body: TabBarView(controller: _tabController, children: [Donate()]),
    ));
  }
}

class Donate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => ListView(
  children: ListTile.divideTiles(
      context: context,
      tiles: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/Hardik_Bagada.jpeg'),
          ),
          title: Text('Hardik Bagada'),
          subtitle: Text('Code, Maintainance, Documentation'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                   shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
      ),      
                      title: Text('Hardik Bagada'),
            content: Text('bagadahardik2000@gmail.com'),
            actions: <Widget>[
            FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('GO BACK')),
            ],
                );
              }
            );
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/Mahendrasinh_Barad.jpeg'),
          ),
          title: Text('Mahendrasinh Barad'),
          subtitle : Text('Code, UI Design, Feedback'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                   shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
      ),      
                      title: Text('Mahendrasinh Barad'),
            content: Text('mahendrasinhbarad123@gmail.com',style: TextStyle(fontSize: 15)),
            actions: <Widget>[
            FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('GO BACK')),
            ],
                );
              }
            );
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/Harshad_Chovatiya.jpg'),
          ),
          title: Text('Harshad Chovatiya'),
          subtitle: Text('Code, Utility Libraries, Testing'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                   shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
      ),      
                      title: Text('Harshad Chovatiya'),
            content: Text('harshadchovatiya9@gmail.com'),
            actions: <Widget>[
            FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('GO BACK')),
            ],
                );
              }
            );
          },
        ),
      ]
  ).toList(),
)
      
    );
  }
}
