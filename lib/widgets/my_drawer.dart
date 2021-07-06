import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, this.width}) : super(key: key);

  final double? width;

  @override
  Widget build(BuildContext context) {
    final materialWidget = Material(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('MAKH'),
                accountEmail: Text('makh@sth.com'),
                currentAccountPicture: FlutterLogo(),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
              ),
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('News'),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Favorites'),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
    return width != null
        ? SizedBox(
            width: width,
            height: double.infinity,
            child: materialWidget,
          )
        : materialWidget;
  }
}
