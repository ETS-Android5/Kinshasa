/* * This file/screen is the second of four tabs the user sees when the app
 * launches. As the name says, it is where the user can see items he has added
 * to his favorites. When there is no favorite, it shows a message. The user can
 * either delete all favorite items by accessing the button from the top right
 * corner. They can also delete only one item by simply clicking the red X button
 * The screen is linked with the FavoritesProvider provider so that when a user
 * clicks on the add to favorites button, the particular drink will be added to
 * a list in the FavoritesProvider file (so that we don't make expensive calls to
 * the database in this file) and provider will notifyListeners().
 * Since the app uses the IndexedStack widget, changes don't reflect unless a 
 * setState is called. This is the problem the provider fixes, with 
 * notifyListeners()
 */

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:kinshasa/widgets/BouncyPageRoute.dart';
import 'package:kinshasa/widgets/Constants.dart';
import 'package:kinshasa/widgets/DBHelper1.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';
import 'package:kinshasa/widgets/FavoritesProvider.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'DetailPage.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var helper;
  FavoritesBloc _favoritesBloc;
  var parser = EmojiParser();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    helper = DBHelper();
    helper.getFavorites().then((rows) {
      setState(() {
        rows.forEach((drink) {
          _favoritesBloc.addDrink(drink);
        });
      });
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
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Product Sans',
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.red[400],
            ),
            onSelected: choiceAction,
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
          return Container(
            child: buildListView(favorites),
          );
        },
      ),
    );
  }

// Show dialog when user tries to delete all items in favorites
// Can be turned on or off in the More screen
  showDeleteAllDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancel',
          style: TextStyle(fontFamily: 'Product Sans'),
        ));

    Widget confirmButton = FlatButton(
        onPressed: () {
          _favoritesBloc.clearList();
          helper.deleteAll();
          Navigator.pop(context);
          showToast();
        },
        splashColor: Colors.red[100],
        child: Text(
          'Delete',
          style: TextStyle(fontFamily: 'Product Sans', color: Colors.red[400]),
        ));

    AlertDialog alertDialog = AlertDialog(
      title: Text(
        'Delete all?',
        style: TextStyle(fontFamily: 'Product Sans'),
      ),
      content: Text('This action cannot be undone'),
      actions: <Widget>[cancelButton, confirmButton],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  // Show dialog when user tries to delete an item in favorites
  // Can be turned on or off in the More screen
  showSingleDeleteDialog(BuildContext context, Drink drink) {
    Widget cancelButton = FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancel',
          style: TextStyle(fontFamily: 'Product Sans'),
        ));

    Widget confirmButton = FlatButton(
        onPressed: () {
          _favoritesBloc.removeDrink(drink);
          _deleteFromFavorites(drink);
          Navigator.pop(context);
          showToast();
        },
        splashColor: Colors.red[100],
        child: Text(
          'Delete',
          style: TextStyle(fontFamily: 'Product Sans', color: Colors.red[400]),
        ));

    AlertDialog alertDialog = AlertDialog(
      content: Text('Delete this item?'),
      actions: <Widget>[cancelButton, confirmButton],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  void choiceAction(String choice) {
    switch (choice) {
      case ConstantsInFavoritesPage.clearAll:
        showDeleteAllDialog(context);
        break;
    }
  }

// Method to delete a drink item from the favorites list. Automatically refreshes
// the view
  void _deleteFromFavorites(Drink drink) async {
    await helper.delete(drink.drinkName).then((value) {
      showToast();
    });
  }

// Snackbar displayed after the user deletes an item from favorites
  showToast() {
    _key.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text('Deleted')
          ],
        ),
      ));
  }

// This is the widget that actually builds out the view
  Widget buildListView(List<Drink> data) {
    return data.length > 0
        ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
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
                              widget: DetailPage(
                            title: data[index].drinkName,
                            imageLink: data[index].imageLink,
                            nutrients: data[index].nutrients,
                            procedure: data[index].procedure,
                            ingredients: data[index].ingredients,
                          ))); //opening the details page
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
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.7,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Nothing here ',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '${parser.get('upside_down_face').code}',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Items you add will appear here',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.4,
                  //color: Colors.black,
                ),
              ],
            ),
          );
  }
}
