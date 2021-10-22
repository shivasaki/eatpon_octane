import 'package:eatpon_octane/import.dart';
import 'package:intl/intl.dart';

class TableAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return Scaffold(
          drawer: AdminDrawer(),
          appBar: AppBar(
            title: Text('テーブル管理'),
          ),
          body: Container(
            padding: const EdgeInsets.all(8),
            // child: TableLists(),
          ),
        );
      } else {
        return _TablesWide();
      }
    });
  }
}

class _TablesWide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/tables')
          .orderBy('position')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');

        if (snapshot == null) return Text('e5909');

        return Scaffold(
          backgroundColor: Colors.white,
          // drawer: AdminDrawer(),
          // appBar: AppBar(
          //   title: Text('オーダー管理'),
          // ),
          body: Row(
            children: [
              EpSideBar(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 16, left: 32, bottom: 16),
                      child: Text('オーダー管理'),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: _TableList(snapshot.data.docs),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TableList extends StatelessWidget {
  final List<QueryDocumentSnapshot> tables;
  _TableList(this.tables);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff6f6f6),
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 162 / 117,
          crossAxisCount: 5,
        ),
        itemCount: tables.length,
        itemBuilder: (BuildContext context, int index) {
          return _Table(tables[index]);
        },
      ),
    );
  }
}

class _Table extends StatelessWidget {
  final QueryDocumentSnapshot rawTable;
  _Table(this.rawTable);

  @override
  Widget build(BuildContext context) {
    final table = rawTable.data();
    if (table == null || !rawTable.exists) {
      return Text('e50354');
    }

    String updatedAt = '-';
    if (table['updatedAt'] is Timestamp) {
      updatedAt = DateFormat('HH:mm').format(table["updatedAt"].toDate());
    }

    String customerCount = '- ';
    if (table['customers'] != null) {
      customerCount = table["customers"].length.toString();
    }

    String totalPrice = '-';
    if (table['totalPrice'] is int) {
      totalPrice = table["totalPrice"].toString();
    }

    Future<void> _resetTable() async {
      await rawTable.reference.update({
        'customers': [],
        'totalPoint': 0,
        'totalPrice': 0,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    }

    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black,
          alignment: Alignment.topLeft,
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(table['name'] ?? '-'),
              ),
              Container(
                child: Text(customerCount + '名'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    updatedAt,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              )
            ],
          ),
        ),
        onPressed: () async {
          await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(8),
                actionsPadding: EdgeInsets.all(8),
                title: Text('お会計'),
                content: Container(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'お支払い金額をお客様に提示してください。',
                        style: TextStyle(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Text(
                          '支払金額',
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '￥' + totalPrice,
                        style: TextStyle(
                          color: Color(0xff1986EB),
                          fontSize: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('キャンセル'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  OutlinedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff1986EB),
                      primary: Colors.white,
                    ),
                    child: Text('会計完了'),
                    onPressed: () async {
                      await _resetTable();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
