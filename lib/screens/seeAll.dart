/* * This file/screen is shown when the user taps on the see all button from the
 * home screen. As the name says, it displays a complete list of juices, smoothies
 * or shakes. 
 * • The drinks are divided into two lists(set1 and set2) and used to
 * build the view
 * • When a user does a long press action on any item, a bottom sheet pops up 
 * with an option for the user to add the item to their favorites. A snackbar is 
 * shown to confirm the action. 
 * • When the user taps on an item, it opens up in the
 * Detail screen to provide all other details.  
 * • In the constructor, the parameters are received from the particular tab from
 * which the user navigated to this screen be it juice, smoothie, or shake. These
 * parameters are used in the app bar, for instance clicking on the see all button
 * in the juice tab on the home screen passes the string -juice to the constructor
 * and it is displayed in the app bar. 
 * • providerCount refers to the number of drink items in total a category of drink
 * has. For example at the time of writing this, juice has 30 items and smoothie
 * has 34.
 * • The page has a scroll handle to help the user scroll down faster
 */

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:kinshasa/screens/DetailPage.dart';
import 'package:kinshasa/widgets/BouncyPageRoute.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';
import 'package:kinshasa/widgets/FrostedAppBar.dart';
import 'package:kinshasa/widgets/DBHelper1.dart';
import 'package:kinshasa/widgets/FavoritesProvider.dart';
import 'package:provider/provider.dart';

class All extends StatefulWidget {
  final String title;
  final int providerCount;
  final List<Drink> set1;
  final List<Drink> set2;
  All({this.title, this.providerCount, this.set1, this.set2});
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  DBHelper helper;
  FavoritesBloc _favoritesBloc;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    helper = DBHelper();
    _favoritesBloc = Provider.of<FavoritesBloc>(context);
  }

// Snackbar shown when the user longpresses on a drink and adds it to their
// favorites
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        // List view of all juice, smoothie, or shake
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          // Scroll handle
          child: DraggableScrollbar.semicircle(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.set1.length,
              itemBuilder: (context, index) {
                return Row(
                  children: <Widget>[
                    // stack list on the left
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                        child: Bounce(
                          duration: Duration(milliseconds: 100),
                          onPressed: () {
                            Navigator.push(
                                context,
                                BouncyPageRoute(
                                    widget: DetailPage(
                                  title: widget.set1[index].drinkName,
                                  imageLink: widget.set1[index].imageLink,
                                  nutrients: widget.set1[index].nutrients,
                                  procedure: widget.set1[index].procedure,
                                  ingredients: widget.set1[index].ingredients,
                                )));
                          },
                          child: GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          )),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await helper
                                                  .insert(widget.set1[index])
                                                  .then((value) {
                                                showToast(
                                                  'Added to favorites',
                                                  icon: Icon(
                                                    Icons.check,
                                                    color: Colors.greenAccent,
                                                  ),
                                                );
                                                _favoritesBloc.addDrink(
                                                    widget.set1[index]);
                                              });
                                            },
                                            child: ListTile(
                                              title: Text(
                                                "Add to favorites",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17.0),
                                              ),
                                              leading: Icon(
                                                Icons.add,
                                                color: Colors.red,
                                                size: 27.0,
                                              ),
                                            ),
                                          )),
                                    );
                                  });
                            },
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Container(
                                          height: 200.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[300],
                                                blurRadius:
                                                    20.0, // has the effect of softening the shadow
                                                offset: Offset(
                                                  10.0, // horizontal, move right 10
                                                  10.0, // vertical, move down 10
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 65.0,
                                                left: 10.0,
                                                right: 10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Flexible(
                                                  child: Material(
                                                      color: Colors.transparent,
                                                      child: Text(
                                                        '${widget.set1[index].drinkName}',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.blueGrey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                                SizedBox(height: 10.0),
                                                Container(
                                                  height: 80.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7.0))),
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(height: 5.0),
                                                      Flexible(
                                                          child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                'cal ${widget.set1[index].calories}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ))),
                                                      SizedBox(height: 5.0),
                                                      Flexible(
                                                          child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                'carbs ${widget.set1[index].carbohydrates}g',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ))),
                                                      SizedBox(height: 5.0),
                                                      Flexible(
                                                          child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                widget.title ==
                                                                        'shake'
                                                                    ? 'protein ${widget.set1[index].proteins}g'
                                                                    : 'sodium ${widget.set1[index].sodium}mg',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ))),
                                                      SizedBox(height: 5.0),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),

                                // image
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: ClipOval(
                                    child: Container(
                                      height: 70.0,
                                      width: 70.0,
                                      color: Colors.grey,
                                      child: Image.asset(
                                        widget.set1[index].imageLink,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // stack list on the right
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        SizedBox(height: 100.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 30.0),
                          child: Bounce(
                            duration: Duration(milliseconds: 100),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  BouncyPageRoute(
                                      widget: DetailPage(
                                    title: widget.set2[index].drinkName,
                                    imageLink: widget.set2[index].imageLink,
                                    nutrients: widget.set2[index].nutrients,
                                    procedure: widget.set2[index].procedure,
                                    ingredients: widget.set2[index].ingredients,
                                  )));
                            },
                            child: GestureDetector(
                              onLongPress: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            )),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 15.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await helper
                                                    .insert(widget.set2[index])
                                                    .then((value) {
                                                  showToast(
                                                    'Added to favorites',
                                                    icon: Icon(
                                                      Icons.check,
                                                      color: Colors.greenAccent,
                                                    ),
                                                  );
                                                  _favoritesBloc.addDrink(
                                                      widget.set2[index]);
                                                });
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  "Add to favorites",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0),
                                                ),
                                                leading: Icon(
                                                  Icons.add,
                                                  color: Colors.red,
                                                  size: 27.0,
                                                ),
                                              ),
                                            )),
                                      );
                                    });
                              },
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: 30.0),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                            height: 200.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[300],
                                                  blurRadius:
                                                      20.0, // has the effect of softening the shadow
                                                  offset: Offset(
                                                    10.0, // horizontal, move right 10
                                                    10.0, // vertical, move down 10
                                                  ),
                                                ) //this is the widget that does the shadow effect around the stacks
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 65.0,
                                                  left: 10.0,
                                                  right:
                                                      10.0), //this gives the space around the name and nutritional value box
                                              child: Column(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                          '${widget.set2[index].drinkName}',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ), //this widget contains the name of the juice
                                                  SizedBox(
                                                      height:
                                                          10.0), //this widget spaces out the juice name from the nutritional value box
                                                  Container(
                                                    height: 80.0,
                                                    child: Column(
                                                      children: <Widget>[
                                                        SizedBox(height: 5.0),
                                                        Flexible(
                                                            child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Text(
                                                                  'cal ${widget.set2[index].calories}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .blueGrey,
                                                                  ),
                                                                ))),
                                                        SizedBox(height: 5.0),
                                                        Flexible(
                                                            child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Text(
                                                                  'carbs ${widget.set2[index].carbohydrates}g',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .blueGrey,
                                                                  ),
                                                                ))),
                                                        SizedBox(height: 5.0),
                                                        Flexible(
                                                            child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Text(
                                                                  widget.title ==
                                                                          'shake'
                                                                      ? 'protein ${widget.set2[index].proteins}g'
                                                                      : 'sodium ${widget.set2[index].sodium}mg',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .blueGrey,
                                                                  ),
                                                                ))),
                                                        SizedBox(height: 5.0),
                                                      ],
                                                    ),
                                                  ) //this is the nutritional value box visible in the stack
                                                ],
                                              ),
                                            )),
                                      ), //this container is the white container on which the juice name lies
                                    ],
                                  ),

                                  // image
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: ClipOval(
                                      child: Container(
                                        height: 70.0,
                                        width: 70.0,
                                        color: Colors.grey,
                                        child: Image.asset(
                                          widget.set2[index].imageLink,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ), //padding for the spacing of every two fruit stack item
                      ],
                    )), // this column is specific and important to achieve the visual effect of every two fruit stack items
                  ],
                );
              },
            ),
          ),
        ),

        // Frosted app bar
        Padding(
          padding: const EdgeInsets.only(top: 26.0),
          child: FrostedAppBar(
            title: Text(
              '${widget.title}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: 'Product Sans'),
            ),
            leading: IconButton(
              iconSize: 30.0,
              icon: Icon(CupertinoIcons.back),
              color: Colors.red[400],
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.providerCount}',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
