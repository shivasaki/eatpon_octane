import 'package:eatpon_octane/import.dart';
import 'package:intl/intl.dart';

class OrderAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return Scaffold(
          drawer: AdminDrawer(),
          appBar: AppBar(
            title: Text('オーダー管理'),
          ),
          body: Container(
            padding: const EdgeInsets.all(8),
            // child: OrderLists(),
          ),
        );
      } else {
        return WideOrderLists();
      }
    });
  }
}

class WideOrderLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/carts')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');

          List newOrders = [];
          List ordersReceived = [];
          List ordersProcessed = [];

          if (snapshot != null) {
            snapshot.data.docs.asMap().forEach((key, cartValue) {
              final docData = cartValue.data();
              if (docData['items'] == null) {
                return Container();
              }
              final itemsData = docData['items'];
              itemsData.asMap().forEach((key, value) {
                if (value['status'] == null || value['status'] == 'new') {
                  newOrders.add({
                    'createdAt': docData['cretedAt'] ?? '-.-',
                    'ref': value['docRef'] ?? '-.-',
                    'options': value['options'],
                    'parentRef': cartValue.reference,
                    'itemIndex': key,
                    'tableId': cartValue.get('table_id'),
                  });
                } else if (value['status'] == 'received') {
                  ordersReceived.add({
                    'createdAt': docData['cretedAt'] ?? '-.-',
                    'ref': value['docRef'] ?? '-.-',
                    'options': value['options'],
                    'parentRef': cartValue.reference,
                    'itemIndex': key,
                    'tableId': cartValue.get('table_id'),
                  });
                } else if (value['status'] == 'processed') {
                  ordersProcessed.add({
                    'createdAt': docData['cretedAt'] ?? '-.-',
                    'ref': value['docRef'] ?? '-.-',
                    'options': value['options'],
                    'parentRef': cartValue.reference,
                    'itemIndex': key,
                    'tableId': cartValue.get('table_id'),
                  });
                }
              });
            });
          }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16, left: 32, bottom: 16),
                        child: Text('オーダー管理'),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16),
                          alignment: Alignment.topLeft,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              OrderList('new', newOrders),
                              OrderList('recieved', ordersReceived),
                              OrderList('processed', ordersProcessed),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class OrderList extends StatelessWidget {
  final String listSelector;
  final List itemsList;
  OrderList(this.listSelector, this.itemsList);

  @override
  Widget build(BuildContext context) {
    final listTypeSwitch = {
      'new': {
        'header': '新規オーダー',
        'statusIcon': null,
      },
      'recieved': {
        'header': '調理中',
        'statusIcon': null,
      },
      'processed': {
        'header': '調理済み',
        'statusIcon': null,
      },
    };

    return Container(
      width: 400,
      color: Color(0xfff6f6f6),
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            color: Color(0xfff0f0f0),
            padding: EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Text(listTypeSwitch[listSelector]['header']),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    alignment: Alignment.centerRight,
                    child: Text(itemsList.length.toString() ?? '-'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: itemsList.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Item(itemsList[index] ?? null);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final rawItem;
  Item(this.rawItem);
  @override
  Widget build(BuildContext context) {
    if (rawItem == null) {
      return Container();
    }
    return FutureBuilder(
      future: rawItem['ref'].get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData == false) {
          return Text("loading...");
        }

        final item = snapshot.data.data();
        final titleAndOptions = [
          Text(
            (item['title'] ?? '-'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ];
        String createdAt = '-';
        if (rawItem['createdAt'] is Timestamp) {
          createdAt =
              DateFormat('MM/dd HH:mm').format(rawItem["createdAt"].toDate());
        }

        rawItem['options'].asMap().forEach(
          (index, option) {
            if (option != null && option['choices'] != null) {
              titleAndOptions.add(
                Text(option['choices'][option['selectedIndex']]),
              );
            }
          },
        );
// TODO represent time left, category and status
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Text('ジャンル'),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(''),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: titleAndOptions,
                    ),
                  ),
                ],
              ),
              Container(
                color: Color(0xffe0e0e0),
                height: 1,
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    _TableName(rawItem['tableId']),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            createdAt, //TODO + '分前',
                            style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 12,
                            ),
                          ),
                          _ItemMenu(rawItem),
                        ],
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

class _ItemMenu extends StatelessWidget {
  final item;
  _ItemMenu(this.item);
  @override
  Widget build(BuildContext context) {
    if (item == null) return Container();
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Color(0xff888888),
      ),
      onSelected: (status) async {
        DocumentReference parentRef = item['parentRef'];
        DocumentSnapshot parent = await parentRef.get();
        List newItems = parent.get('items');
        newItems[item['itemIndex']]['status'] = status;
        await parentRef.update({'items': newItems});
        if (status == 'archived') {
          String parentId = parentRef.id;
          bool shouldDeleted = false;
          if (newItems.length == 1) {
            shouldDeleted = true;
          }
          DocumentSnapshot _doc = await FirebaseFirestore.instance
              .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/archivedCarts')
              .doc(parentId)
              .get();
          if (_doc.exists) {
            await FirebaseFirestore.instance
                .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/archivedCarts')
                .doc(parentId)
                .update({'items': newItems});
          } else {
            await FirebaseFirestore.instance
                .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/archivedCarts')
                .doc(parentId)
                .set({'items': newItems});
          }
          if (shouldDeleted) await parentRef.delete();
        }
      },
      itemBuilder: (BuildContext context) {
        final List<PopupMenuEntry> list = [
          PopupMenuItem(
            child: Text('新規オーダーに変更'),
            value: 'new',
          ),
          PopupMenuItem(
            child: Text('調理中に変更'),
            value: 'received',
          ),
          PopupMenuItem(
            child: Text('調理済みに変更'),
            value: 'processed',
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            child: Text('提供済み'),
            value: 'archived',
          ),
        ];
        return list;
      },
    );
  }
}

class _TableName extends StatelessWidget {
  final String tableId;
  _TableName(this.tableId);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/tables')
            .doc(tableId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData == false) {
            return Text("loading...");
          }

          String tableName = '-';
          if (snapshot.data.exists) {
            tableName = snapshot.data.get('name');
          }

          return Text(
            tableName,
            style: TextStyle(
              color: Color(0xff999999),
              fontSize: 12,
            ),
          );
        });
  }
}
