import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class JuiceTabContents extends StatefulWidget {
  @override
  _JuiceTabContentsState createState() => _JuiceTabContentsState();
}

class _JuiceTabContentsState extends State<JuiceTabContents> {
  var inheritedWidget;
  List<Drink> selectedDrinks;
  List<Drink> set1;
  List<Drink> set2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inheritedWidget = MyInheritedWidget.of(context);
    selectedDrinks = List.generate(inheritedWidget.juiceList.length ~/ 4, (i) {
      return inheritedWidget.juiceList[i];
    });
    set1 = List.generate(inheritedWidget.juiceList.length ~/ 2, (i) {
      return inheritedWidget.juiceList[i];
    });
    set2 = inheritedWidget.juiceList
        .getRange(
          inheritedWidget.juiceList.length ~/ 2,
          inheritedWidget.juiceList.length,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BuildTab(
      title: 'juice',
      set1: set1,
      set2: set2,
      selectedDrinks: selectedDrinks,
    );
  }
}
