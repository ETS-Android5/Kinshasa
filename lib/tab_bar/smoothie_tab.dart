import 'package:flutter/material.dart';
import 'package:kinshasa/models/drink.dart';
import 'package:kinshasa/widgets/inherited_widget.dart';
import 'package:kinshasa/widgets/tab.dart';

class SmoothieTabContents extends StatefulWidget {
  @override
  _SmoothieTabContentsState createState() => _SmoothieTabContentsState();
}

class _SmoothieTabContentsState extends State<SmoothieTabContents> {
  var provider;
  List<Drink> set1;
  List<Drink> set2;
  List<Drink> selectedDrinks;

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
  Widget build(BuildContext context) {
    return BuildTab(
      title: 'smoothie',
      set1: set1,
      set2: set2,
      selectedDrinks: selectedDrinks,
    );
  }
}
