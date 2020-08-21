import 'package:flutter/material.dart';
import 'package:kinshasa/widgets/FavoritesProvider.dart';
import 'package:provider/provider.dart';

import 'screens/Start.dart';
import 'widgets/DBHelper.dart';
import 'widgets/DrinkModel.dart';
import 'widgets/InheritedWidget.dart';

void main() async {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Drink> juiceData = [];
  List<Drink> smoothieData = [];
  List<Drink> shakeData = [];
  List<Drink> favoriteDrinkData = [];
  int juiceCount;
  int smoothieCount;
  int shakeCount;

  @override
  void initState() {
    super.initState();

    // fetching the juice data and updating the juiceData list
    helper.getJuiceData().then((rows) {
      rows.shuffle();
      setState(() {
        rows.forEach((row) {
          juiceData.add(Drink.fromMap(row));
        });
      });
    });

    // fetching the smoothie data and updating the smoothieData list
    helper.getSmoothieData().then((rows) {
      rows.shuffle();
      setState(() {
        rows.forEach((row) {
          smoothieData.add(Drink.fromMap(row));
        });
      });
    });

    // fetching the shake data and updating the shakeData list
    helper.getShakeData().then((rows) {
      rows.shuffle();
      setState(() {
        rows.forEach((row) {
          shakeData.add(Drink.fromMap(row));
        });
      });
    });

    // get the number of juice data in database
    helper.getJuiceCount().then((value) {
      setState(() {
        juiceCount = value;
      });
    });

    // get the number of smoothie data in database
    helper.getSmoothieCount().then((value) {
      setState(() {
        smoothieCount = value;
      });
    });

    // get the number of shake data in database
    helper.getShakeCount().then((value) {
      setState(() {
        shakeCount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FavoritesBloc(favorites: favoriteDrinkData),
            lazy: false,
          )
        ],
        child: MyInheritedWidget(
          juiceList: juiceData,
          smoothieList: smoothieData,
          shakeList: shakeData,
          juiceCount: juiceCount,
          smoothieCount: smoothieCount,
          shakeCount: shakeCount,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              accentColor: Colors.red[400],
              visualDensity: VisualDensity.adaptivePlatformDensity,
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
              ),
            ),
            home: Start(),
          ),
        ));
  }
}
