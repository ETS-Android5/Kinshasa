import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inheritedWidget;
  var items = [];
  Random random = Random();
  DBHelper dbHelper = DBHelper();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inheritedWidget = MyInheritedWidget.of(context);
    var lst = [
      ...inheritedWidget.juiceList,
      ...inheritedWidget.smoothieList,
      ...inheritedWidget.shakeList,
    ];
    items.addAll(lst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Search',
            style: TextStyle(color: Colors.black, fontFamily: 'Product Sans'),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.red[400],
                      style: TextStyle(fontSize: 18.0),
                      controller: _textEditingController,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) => filterSearchResults(value),
                      decoration: InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: 'Search Juice, Smoothie, Shake',
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(130.0),
                        ),
                        prefixIcon: _textEditingController.text.isEmpty
                            ? Icon(
                                Icons.search,
                                size: 25.0,
                                color: Colors.black,
                              )
                            : Container(width: 10.0),
                        suffixIcon: _textEditingController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red[400],
                                ),
                                onPressed: () => _textEditingController.clear(),
                              )
                            : null,
                      ),
                    ),
                  ),
                  _textEditingController.text.isNotEmpty
                      ? Padding(
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
                      : Container()
                ],
              ),
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
                                          widget: DrinkDetail(item)));
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

  void filterSearchResults(String query) {
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
  int randomListItem() => random.nextInt(items.length);

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

  Widget buildListTile() {
    TextStyle style = TextStyle(color: Colors.red[400]);
    var item = items[randomListItem()];
    return ListTile(
        title: Text(
          '${item.drinkName}',
          style: style,
        ),
        onTap: () {
          Navigator.push(context, BouncyPageRoute(widget: DrinkDetail(item)));
        });
  }
}
