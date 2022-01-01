import 'package:kinshasa/shared/exports.dart';

class FavoritesController extends GetxController {
  var favorites = [].obs;
  bool shouldConfirmBeforeDelete;

  void addDrink(Drink drink) {
    favorites.add(drink);
    update();
  }

  Future<void> removeFromFavorites(Drink drink) async {
    try {
      favorites.remove(drink);
      update();
      await DBHelper().delete(drink.drinkName);
      Utils.showToast('Success', 'Item removed');
    } catch (error) {
      Utils.showToast('Oops', 'Error removing item');
    }
  }

  void clearList() {
    favorites.clear();
    update();
  }

  Future<void> clearFavorites() async {
    try {
      clearList();
      DBHelper().deleteAll();
      Utils.showToast('Success', 'Item removed');
    } catch (error) {
      Utils.showToast('Oops', 'Error removing items');
    }
  }

  void setDeletePreference(bool value) {
    shouldConfirmBeforeDelete = value;
    update();
  }

  @override
  void onReady() {
    DBHelper().getFavorites().then((rows) {
      favorites.addAll(rows);
    });

    SharedPreferencesHelper.getDeleteConfirmationPreference().then((value) {
      setDeletePreference(value);
    });
    super.onReady();
  }
}
