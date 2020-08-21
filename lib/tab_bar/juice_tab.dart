/* * This file/view exists for the following reason:
 * • Juice, Smoothie, and Shake have different sizes. And because the seeAll 
 * screen requires the number of items of each category (for display in the 
 * app bar), there had to be a way to pass that together with other vital information
 * to the seeAll screen. 
 * • The list of juices is divided into two parts (set1 and set2) and passed to
 * seeAll screen to be used in the building of the view.
 * • selectedDrinks refers to the drinks that are/have been selected for display
 * in the respective tabs on the home screen. (selection is done randomaly)
 * • The structure of this tab is constructed in a widgets/tab.dart. It has been
 * referenced on line 53
 * • Everything said here applies directly to shake_tab and smoothie_tab
 */

import 'package:flutter/material.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';
import 'package:kinshasa/widgets/InheritedWidget.dart';
import 'package:kinshasa/widgets/tab.dart';

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
    setState(() {
      inheritedWidget = MyInheritedWidget.of(context);
      selectedDrinks =
          List.generate(inheritedWidget.juiceList.length ~/ 4, (i) {
        return inheritedWidget.juiceList[i];
      });
      set1 = List.generate(inheritedWidget.juiceList.length ~/ 2, (i) {
        return inheritedWidget.juiceList[i];
      });
      set2 = inheritedWidget.juiceList
          .getRange(inheritedWidget.juiceList.length ~/ 2,
              inheritedWidget.juiceList.length)
          .toList();
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BuildTab(
      title: 'juice',
      drinkCount: inheritedWidget.juiceCount,
      set1: set1,
      set2: set2,
      selectedDrinks: selectedDrinks,
    );
  }
}
