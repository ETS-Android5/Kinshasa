/* * To avoid making expensive calls to the favorites database, this file was 
 * created. When the app starts, the user's favorite items are fetched and stored
 * in the favorites list of this class. This list can then be accessed by the 
 * FavoritesScreen without having to contact the database. 
 */

import 'package:flutter/cupertino.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';

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
