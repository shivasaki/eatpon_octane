import 'package:eatpon_octane/import.dart';
import 'package:eatpon_octane/models.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartsModel>(
          create: (_) => CartsModel(),
        ),
        // ChangeNotifierProvider<OrdersRecievedModel>(
        //   create: (_) => OrdersRecievedModel(),
        // ),
        // ChangeNotifierProvider<OrdersProcessedModel>(
        //   create: (_) => OrdersProcessedModel(),
        // ),
      ],
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatpon',
      initialRoute: '/',
      routes: {
        '/': (context) => OrderAdmin(),
        '/order_admin': (context) => OrderAdmin(),
        // '/point_admin': (context) => PointAdmin(),
        '/table_admin': (context) => TableAdmin(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
    );
  }
}
