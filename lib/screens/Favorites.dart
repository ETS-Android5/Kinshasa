import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  DBHelper helper = DBHelper();
  FavoritesBloc _favoritesBloc;
  EmojiParser parser = EmojiParser();

  @override
  void initState() {
    super.initState();
    helper.getFavorites().then((rows) {
      rows.forEach((drink) {
        _favoritesBloc.addDrink(drink);
      });
    });

    SharedPreferencesHelper.getDeleteConfirmationPreference().then((value) {
      _favoritesBloc.setDeletePreference(value);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favoritesBloc = Provider.of<FavoritesBloc>(context);
  }

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
      body: Consumer<FavoritesBloc>(
        builder: (context, instance, child) {
          List<Drink> favorites = instance.favorites.reversed.toList();
          return Container(child: buildListView(favorites));
        },
      ),
    );
  }

  void onOptionSelected(String choice) {
    switch (choice) {
      case ConstantsInFavoritesPage.clearAll:
        showDeleteAllDialog(context);
        break;
    }
  }

  Widget buildListView(List<Drink> data) {
    return data.length > 0
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text('${data[index].drinkName}'),
                    leading: ClipOval(
                      child: Image.asset(
                        data[index].imageLink,
                        fit: BoxFit.cover,
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        LineAwesomeIcons.remove,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        if (_favoritesBloc.shouldConfirmBeforeDelete)
                          showSingleDeleteDialog(context, data[index]);
                        else {
                          _favoritesBloc.removeDrink(data[index]);
                          _deleteFromFavorites(data[index]);
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        BouncyPageRoute(
                          widget: DrinkDetail(data[index]),
                        ),
                      );
                    },
                  ),
                  Divider()
                ],
              );
            },
          )
        : Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(height: MediaQuery.of(context).size.height / 2.7),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nothing here ',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text(
                          '${parser.get('upside_down_face').code}',
                          style: TextStyle(fontSize: 20.0),
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Items you add will appear here',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Container(height: MediaQuery.of(context).size.height / 2.4),
              ],
            ),
          );
  }

  void showDeleteAllDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel', style: TextStyle(fontFamily: 'Product Sans')),
    );

    Widget confirmButton = TextButton(
      onPressed: () {
        _favoritesBloc.clearList();
        helper.deleteAll();
        Navigator.pop(context);
        Utils.showToast('Success', 'Item removed');
      },
      child: Text(
        'Delete',
        style: TextStyle(fontFamily: 'Product Sans', color: Colors.red[400]),
      ),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Delete all?', style: TextStyle(fontFamily: 'Product Sans')),
      content: Text('This action cannot be undone'),
      actions: [cancelButton, confirmButton],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  void showSingleDeleteDialog(BuildContext context, Drink drink) {
    Widget cancelButton = TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel', style: TextStyle(fontFamily: 'Product Sans')));

    Widget confirmButton = TextButton(
        onPressed: () {
          _favoritesBloc.removeDrink(drink);
          _deleteFromFavorites(drink);
          Navigator.pop(context);
          Utils.showToast('Success', 'Item removed');
        },
        child: Text(
          'Delete',
          style: TextStyle(fontFamily: 'Product Sans', color: Colors.red[400]),
        ));

    AlertDialog alertDialog = AlertDialog(
      content: Text('Delete this item?'),
      actions: [cancelButton, confirmButton],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  Future<void> _deleteFromFavorites(Drink drink) async {
    await helper.delete(drink.drinkName).then((value) {
      Utils.showToast('Success', 'Item removed');
    });
  }
}
