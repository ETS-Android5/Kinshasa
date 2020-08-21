/* * This file is the backbone of the app. It defines the structure of a drink
 * item. It also provides useful methods for conveting objects to a map so that
 * the database can accept it and from a map to a drink object so that it can
 * be used in the UI of the app
 */

class Drink {
  String drinkName;
  String imageLink;
  String ingredients;
  String procedure;
  String nutrients;
  var calories;
  var carbohydrates;
  var sodium;
  var proteins;

  Drink({
    this.drinkName,
    this.imageLink,
    this.ingredients,
    this.procedure,
    this.nutrients,
  });

  // Convert the map object returned by the juice/smoothie/shake table to a
  // drink object
  Drink.fromMap(dynamic obj) {
    this.drinkName = obj['Name'];
    this.imageLink = obj['Image'];
    this.ingredients = obj['Ingredients'];
    this.procedure = obj['Procedure'];
    this.nutrients = obj['Nutrients'];
    this.calories = obj['Calories'];
    this.carbohydrates = obj['Carbohydrates'];
    this.sodium = obj['Sodium'];
    this.proteins = obj['Protein'];
  }

  // Convert the map object returned by the favorites table to a drink object
  Drink.fromFavoriteMap(dynamic obj) {
    this.drinkName = obj['DrinkName'];
    this.imageLink = obj['ImageLink'];
    this.ingredients = obj['Ingredients'];
    this.procedure = obj['Procedure'];
    this.nutrients = obj['Nutrients'];
  }

  // Convert a drink to a map object for insertion into the favorites table
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'DrinkName': drinkName,
      'ImageLink': imageLink,
      'Ingredients': ingredients,
      'Procedure': procedure,
      'Nutrients': nutrients,
    };
  }
}
