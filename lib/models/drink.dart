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

  Drink.fromFavoriteMap(dynamic obj) {
    this.drinkName = obj['DrinkName'];
    this.imageLink = obj['ImageLink'];
    this.ingredients = obj['Ingredients'];
    this.procedure = obj['Procedure'];
    this.nutrients = obj['Nutrients'];
  }

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
