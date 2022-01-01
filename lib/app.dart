import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Drink> juiceData = [];
  List<Drink> smoothieData = [];
  List<Drink> shakeData = [];

  @override
  void initState() {
    super.initState();
    helper.getJuiceData().then((rows) {
      rows.shuffle();
      setState(() {
        rows.forEach((row) {
          juiceData.add(Drink.fromMap(row));
        });
      });
    });

    helper.getSmoothieData().then((rows) {
      rows.shuffle();
      setState(() {
        rows.forEach((row) {
          smoothieData.add(Drink.fromMap(row));
        });
      });
    });

    helper.getShakeData().then((rows) {
      rows.shuffle();
      setState(() {
        rows.forEach((row) {
          shakeData.add(Drink.fromMap(row));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FavoritesController());
    return MyInheritedWidget(
      juiceList: juiceData,
      shakeList: shakeData,
      smoothieList: smoothieData,
      child: GetMaterialApp(
        home: BottomTab(),
        theme: theme(context),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
