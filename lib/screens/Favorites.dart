import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key key}) : super(key: key);

  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(color: Colors.black, fontFamily: 'Product Sans'),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.red[400]),
            onSelected: onOptionSelected,
            itemBuilder: (context) {
              return ConstantsInFavoritesPage.choices.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          )
        ],
      ),
      body: Obx(
        () {
          var favorites = favoritesController.favorites.reversed.toList();
          return favorites.length > 0
              ? ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${favorites[index].drinkName}'),
                      leading: ClipOval(
                        child: Image.asset(
                          favorites[index].imageLink,
                          fit: BoxFit.cover,
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove, color: Colors.red[400]),
                        onPressed: () {
                          favoritesController
                              .removeFromFavorites(favorites[index]);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          BouncyPageRoute(
                            widget: DrinkDetail(favorites[index]),
                          ),
                        );
                      },
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nothing here',
                          style: TextStyle(fontSize: 20.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Items you add will appear here',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                );
        },
      ),
    );
  }

  void onOptionSelected(String choice) {
    switch (choice) {
      case ConstantsInFavoritesPage.clearAll:
        favoritesController.clearFavorites();
        break;
    }
  }
}
