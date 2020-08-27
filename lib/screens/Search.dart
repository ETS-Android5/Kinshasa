/* * This file/screen is the second of the four tabs the user sees when the app
 * launches. As the name says, it allows the user to search for any drink that 
 * is available from the database. It has a little suggestion block below the 
 * search bar that displays three random drinks from the list of drinks. This 
 * list is a combination of the drinks from the juice, smoothie, and shake table
 * of the DRINK database.
 * 
 */

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kinshasa/widgets/BouncyPageRoute.dart';
import 'package:kinshasa/widgets/DBHelper1.dart';
import 'package:kinshasa/widgets/InheritedWidget.dart';

import 'DetailPage.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();
  var inheritedWidget;
  static var items = [];
  var random = Random();
  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inheritedWidget = MyInheritedWidget.of(context);
    var lst = [
      ...inheritedWidget.juiceList,
      ...inheritedWidget.smoothieList,
      ...inheritedWidget.shakeList
    ];
    items.addAll(lst);
  }

  // Function to filter search results based on user query
  filterSearchResults(String query) {
    var dummySearchList = [];
    dummySearchList.addAll([
      ...inheritedWidget.juiceList,
      ...inheritedWidget.smoothieList,
      ...inheritedWidget.shakeList
    ]);
    if (query.isNotEmpty) {
      var dummyListData = [];
      dummyListData = dummySearchList
          .where((element) => element.drinkName.contains(query))
          .toList();

      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll([
          ...inheritedWidget.juiceList,
          ...inheritedWidget.smoothieList,
          ...inheritedWidget.shakeList
        ]);
      });
    }
  }

  // Function to return a randomly selected item from the drink list
  int randomListItem() {
    return random.nextInt(items.length);
  }

  // Method to construct the three suggested items
  Widget buildSuggestedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildListTile(),
        Divider(),
        buildListTile(),
        Divider(),
        buildListTile(),
        Divider(),
      ],
    );
  }

  // This method is written to prevent repetitive code for navigating to the
  // detail page for each of the three suggested list items
  Widget buildListTile() {
    TextStyle style = TextStyle(color: Colors.red[400]);
    var item = items[randomListItem()];
    return ListTile(
        title: Text(
          '${item.drinkName}',
          style: style,
        ),
        onTap: () {
          Navigator.push(
              context,
              BouncyPageRoute(
                  widget: DetailPage(
                title: item.drinkName,
                imageLink: item.imageLink,
                nutrients: item.nutrients,
                procedure: item.procedure,
                ingredients: item.ingredients,
              )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Search',
            style: TextStyle(color: Colors.black, fontFamily: 'Product Sans'),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              // Padding around the search box
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),

                // Actual search bar
                // We use a row because we want to show a cancel button at the
                // farmost right when the user starts typing. The cancel button
                // closes the search screen and sends the user to the home screen
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        textCapitalization: TextCapitalization.words,
                        autofocus: false,
                        enableSuggestions: true,
                        style: TextStyle(fontSize: 18.0),
                        controller: _textEditingController,
                        cursorColor: Colors.red[400],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          isDense: true,
                          hintText: 'Search Juice, Smoothie, Shake',
                          filled: true,
                          fillColor: Color.fromRGBO(142, 142, 147, .15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(130.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: _textEditingController.text.isEmpty
                              ? Icon(
                                  Icons.search,
                                  size: 25.0,
                                  color: Colors.black,
                                )
                              : Container(
                                  width: 10.0,
                                ),
                          suffixIcon: _textEditingController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.red[400],
                                  ),
                                  onPressed: () {
                                    _textEditingController.clear();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    _textEditingController.text.isNotEmpty
                        ?
                        // Show the cancel button when the user starts typing
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        :
                        // Show nothing when the user isn't typing
                        Container()
                  ],
                ),
              ),

              // When the user starts typing, this is the widget that builds out
              // the search results or the suggested drinks block
              Expanded(
                child: _textEditingController.text.isNotEmpty
                    ?
                    // If the user is typing, the suggested block disappears and
                    // search results are loaded into view
                    ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('${item.drinkName}'),
                                leading: Icon(Icons.search),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      BouncyPageRoute(
                                          widget: DetailPage(
                                        title: item.drinkName,
                                        imageLink: item.imageLink,
                                        nutrients: item.nutrients,
                                        procedure: item.procedure,
                                        ingredients: item.ingredients,
                                      )));
                                },
                              ),
                              Divider()
                            ],
                          );
                        },
                      )
                    :
                    // Sussgested block shown when the search box is empty
                    ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, top: 28.0, bottom: 3.0),
                            child: Container(
                              child: Text(
                                'Suggested',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Divider(),
                          buildSuggestedItems()
                        ],
                      ),
              )
            ],
          ),
        ));
  }
}
