import 'package:eatpon_octane/import.dart';

class PointAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('ポイント管理'),
      ),
    );
  }
}
