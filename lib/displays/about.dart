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
            children: <Widget>[
              ListTile(
                title: Text(
                  "Displayed Soon..",
                )
              )
            ],
          ),
    );
  }

}
