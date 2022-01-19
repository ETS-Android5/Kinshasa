import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class All extends StatefulWidget {
  final String title;
  final List<Drink> set1;
  final List<Drink> set2;
  All({this.title, this.set1, this.set2});
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  DBHelper helper = DBHelper();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: DraggableScrollbar.semicircle(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.set1.length,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 30.0),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        // stack list on the left
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 10.0),
                            child: Bounce(
                              duration: Duration(milliseconds: 100),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  BouncyPageRoute(
                                    widget: DrinkDetail(widget.set1[index]),
                                  ),
                                );
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
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                          '${widget.set1[index].drinkName}',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Colors
                                                                  .blueGrey,
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

                        // stack list on the right
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 100.0),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 30.0),
                                child: Bounce(
                                  duration: Duration(milliseconds: 100),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      BouncyPageRoute(
                                        widget: DrinkDetail(widget.set2[index]),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
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
                                                  padding: const EdgeInsets
                                                          .only(
                                                      top: 65.0,
                                                      left: 10.0,
                                                      right:
                                                          10.0), //this gives the space around the name and nutritional value box
                                                  child: Column(
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Text(
                                                              '${widget.set2[index].drinkName}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
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
                                                            SizedBox(
                                                                height: 5.0),
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
                                                            SizedBox(
                                                                height: 5.0),
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
                                                            SizedBox(
                                                                height: 5.0),
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
                                                            SizedBox(
                                                                height: 5.0),
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
                              ), //padding for the spacing of every two fruit stack item
                            ],
                          ),
                        ), // this column is specific and important to achieve the visual effect of every two fruit stack items
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: kToolbarHeight,
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
                        '${(widget.set1 + widget.set2).length}',
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
        ),
      ),
    );
  }
}
