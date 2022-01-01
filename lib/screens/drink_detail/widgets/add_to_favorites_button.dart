import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class AddToFavoritesButton extends StatelessWidget {
  final Drink drink;
  AddToFavoritesButton({Key key, @required this.drink}) : super(key: key);

  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 100),
      onPressed: () => addToFavorites(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 90.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                Text(
                  'Add to favorites'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addToFavorites(BuildContext context) async {
    try {
      await DBHelper().insert(drink);
      Utils.showToast('Success', 'Your juice has been added to favorites');
      favoritesController.addDrink(drink);
    } catch (error) {
      Utils.showToast('Oops', 'Already in favorites');
    }
  }
}
