import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class FavoritesBloc extends ChangeNotifier {
  FavoritesBloc({this.favorites});
  List<Drink> favorites;
  bool shouldConfirmBeforeDelete;

  void addDrink(Drink drink) {
    favorites.add(drink);
    notifyListeners();
  }

  void removeDrink(Drink drink) {
    favorites.remove(drink);
    notifyListeners();
  }

  void clearList() {
    favorites.clear();
    notifyListeners();
  }

  void setDeletePreference(bool value) {
    shouldConfirmBeforeDelete = value;
    notifyListeners();
  }
}

// class FavoritesController extends GetxController {}
