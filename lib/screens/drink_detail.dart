import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';
import 'package:kinshasa/widgets/MyTemplate.dart';

class DrinkDetail extends StatefulWidget {
  final Drink drink;

  DrinkDetail(this.drink);

  @override
  _DrinkDetailState createState() => _DrinkDetailState();
}

class _DrinkDetailState extends State<DrinkDetail> {
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
            widget.drink.drinkName,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: (ScrollUpdateNotification notification) {
          setState(() {
            if (notification.metrics.pixels > 150 && !showTitle) {
              showTitle = true;
            } else if (notification.metrics.pixels < 135 && showTitle) {
              showTitle = false;
            }
          });
          return;
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
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
                        child: Image.asset(widget.drink.imageLink,
                            fit: BoxFit.cover),
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
                            child: Image.asset(widget.drink.imageLink),
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
                            '${widget.drink.drinkName}',
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
            buildCardItem(
                context, 'Ingredients', this.widget.drink.ingredients),
            buildCardItem(
                context, 'How to prepare', this.widget.drink.procedure),
            buildCardItem(
                context, 'Nutrients per serving', this.widget.drink.nutrients),

            // Add to favorites button
            Bounce(
              duration: Duration(milliseconds: 100),
              onPressed: () => addToFavorites(),
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

/* todo: There is a problem where a drink can be inserted into favorites more
than once. Fix it!
*/

  void addToFavorites() async {
    Drink drink = Drink(
      drinkName: widget.drink.drinkName,
      imageLink: widget.drink.imageLink,
      ingredients: widget.drink.ingredients,
      procedure: widget.drink.procedure,
      nutrients: widget.drink.nutrients,
    );

    try {
      await helper.insert(drink);
      Utils.showToast('Success', 'Your juice has been added to favorites');
      _favoritesBloc.addDrink(drink);
    } catch (error) {
      Utils.showToast('Oops', 'Already in favorites');
    }
  }
}
