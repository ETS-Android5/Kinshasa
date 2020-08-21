import 'package:flutter/material.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';
import 'package:kinshasa/widgets/InheritedWidget.dart';
import 'package:kinshasa/widgets/tab.dart';

class SmoothieTabContents extends StatefulWidget {
  @override
  _SmoothieTabContentsState createState() => _SmoothieTabContentsState();
}

class _SmoothieTabContentsState extends State<SmoothieTabContents> {
  var provider;
  List<Drink> selectedDrinks;
  List<Drink> set1;
  List<Drink> set2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      provider = MyInheritedWidget.of(context);
      selectedDrinks = List.generate(provider.smoothieList.length ~/ 4, (i) {
        return provider.smoothieList[i];
      });
      set1 = List.generate(provider.smoothieList.length ~/ 2, (i) {
        return provider.smoothieList[i];
      });
      set2 = provider.smoothieList
          .getRange(
              provider.smoothieList.length ~/ 2, provider.smoothieList.length)
          .toList();
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BuildTab(
      title: 'smoothie',
      drinkCount: provider.smoothieCount,
      set1: set1,
      set2: set2,
      selectedDrinks: selectedDrinks,
    );
  }
}
