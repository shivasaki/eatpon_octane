// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class TableInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Text('テーブル'),
            Text('合計金額'),
            Text('¥-'),
            Text('来店者 -名'),
            Text('- -回来店'),
            Text('-人来店'),
            Text('人数追加'),
            Text('来店形態'),
            Text('家族'),
            Text('備考'),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 100,
        child: Container(
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  return null;
                },
                child: Text('来店取り消し'),
              ),
              ElevatedButton(
                onPressed: () {
                  return null;
                },
                child: Text('会計完了'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
