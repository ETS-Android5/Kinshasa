/* *This file/screen is what opens when a user taps on a drink item on any screen
 * It displays the details of the selected drink. Name of drink, image, the ing-
 * redients, the procedure, nutrients per serving and a add-to-favorites button
 * that allows the user to add the current open drink item to their favorite list
 * are the components of this page
 */

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:kinshasa/widgets/DBHelper1.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';
import 'package:kinshasa/widgets/FavoritesProvider.dart';
import 'package:kinshasa/widgets/MyTemplate.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String imageLink;
  final String ingredients;
  final String procedure;
  final String nutrients;

  DetailPage({
    this.title,
    this.imageLink,
    this.ingredients,
    this.procedure,
    this.nutrients,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DBHelper helper;
  bool showTitle = false;
  FavoritesBloc _favoritesBloc;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    helper = DBHelper();
    _favoritesBloc = Provider.of<FavoritesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: showTitle ? 1.0 : 0.0,
        leading: IconButton(
          iconSize: 30.0,
          icon: Icon(CupertinoIcons.back),
          color: Colors.red[400],
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: AnimatedOpacity(
          opacity: showTitle ? 1.0 : 0.0,
          duration: Duration(milliseconds: showTitle ? 0 : 0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
      body:
          // This widget wraps around the actual body for a reason.
          // It is used to check where the user has scrolled up to so that the name
          // of the drink can be shifted from the body into the app bar.
          NotificationListener(
        // ignore: missing_return
        onNotification: (ScrollUpdateNotification notification) {
          setState(() {
            if (notification.metrics.pixels > 150 && !showTitle) {
              showTitle = true;
            } else if (notification.metrics.pixels < 135 && showTitle) {
              showTitle = false;
            }
          });
        },
        child: ListView(
          children: <Widget>[
            // Image and name of drink in the top of detail page
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  // Drink image
                  GestureDetector(
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueGrey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(widget.imageLink, fit: BoxFit.cover),
                      ),
                    ),
                    onTap: () {
                      final popup = BeautifulPopup.customize(
                        context: context,
                        build: (options) => MyTemplate(options),
                      );
                      popup.show(
                        title: '',
                        content: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.transparent,
                            child: Image.asset(widget.imageLink),
                          ),
                        ),
                      );
                    },
                  ),

                  // Drink name
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${widget.title}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Divider(),
            buildCardItem(context, 'Ingredients', this.widget.ingredients),
            buildCardItem(context, 'How to prepare', this.widget.procedure),
            buildCardItem(
                context, 'Nutrients per serving', this.widget.nutrients),

            // Add to favorites button
            Bounce(
              duration: Duration(milliseconds: 100),
              onPressed: _insert,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90.0),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Add to favorites'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ],
                        )),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// This widget is used to construct the ingredients, how to prepare and
// nutrients per serving sections.
  Widget buildCardItem(BuildContext context, String item, String item1) {
    TextStyle style1 = TextStyle(
      fontSize: 18.0,
      color: Colors.grey[700],
    );
    TextStyle style2 = TextStyle(
        fontSize: 17.0, color: Colors.grey, wordSpacing: 0.5, height: 2.0);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 40.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    item,
                    style: style1,
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Material(
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Text(
                    item1,
                    style: style2,
                  )),
            ),
          ),
        )
      ],
    );
  }

// Snackbar displayed after the user adds the drink to his favorite list
  showToast(String message, {Widget icon}) {
    _key.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            icon,
            SizedBox(
              width: 5.0,
            ),
            Text(message)
          ],
        ),
      ));
  }

/* todo: There is a problem where a drink can be inserted into favorites more
than once. Fix it!
*/

// Method to insert a drink into the favorites database
  void _insert() async {
    Drink drink = Drink(
      drinkName: widget.title,
      imageLink: widget.imageLink,
      ingredients: widget.ingredients,
      procedure: widget.procedure,
      nutrients: widget.nutrients,
    );

    try {
      await helper.insert(drink).then((value) {
        showToast(
          'Added to favorites',
          icon: Icon(
            Icons.check,
            color: Colors.greenAccent,
          ),
        );
        _favoritesBloc.addDrink(drink);
      });
    } catch (error) {
      showToast('Already in favorites',
          icon: Icon(
            Icons.check,
            color: Colors.blue,
          ));
    }
  }
}
