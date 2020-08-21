/* * This widget provides us a way to make the juice, smoothie, and shake data
 * available across the app.
 */

import 'package:flutter/widgets.dart';
import 'DrinkModel.dart';

class MyInheritedWidget extends InheritedWidget {
  final List<Drink> juiceList;
  final List<Drink> smoothieList;
  final List<Drink> shakeList;
  final List<Drink> favoriteDrinks;
  final int juiceCount;
  final int smoothieCount;
  final int shakeCount;
  MyInheritedWidget({
    Key key,
    Widget child,
    this.juiceList,
    this.smoothieList,
    this.shakeList,
    this.favoriteDrinks,
    this.juiceCount,
    this.smoothieCount,
    this.shakeCount,
  }) : super(key: key, child: child);

  static MyInheritedWidget of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>());
  }

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return true;
  }
}
