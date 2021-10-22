import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              '管理メニュー',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/order_admin');
              },
              child: Text('オーダー管理'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/point_admin');
              },
              child: Text('ポイント管理'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/table_admin');
              },
              child: Text('テーブル管理'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
