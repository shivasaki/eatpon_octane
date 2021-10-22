import 'package:flutter/material.dart';

class EpSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Color(0xfff6f6f6),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text("オーダー管理"),
            onTap: () {
              Navigator.pushNamed(context, '/order_admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.view_module),
            title: Text("テーブル管理"),
            onTap: () {
              Navigator.pushNamed(context, '/table_admin');
            },
          ),
        ],
      ),
    );
  }
}
