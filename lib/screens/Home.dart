import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinshasa/tab_bar/juice_tab.dart';
import 'package:kinshasa/tab_bar/shake_tab.dart';
import 'package:kinshasa/tab_bar/smoothie_tab.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime now;
  String formattedDate;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    formattedDate = DateFormat('EEEE, d MMMM').format(now).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Product Sans',
                        ),
                      ),
                      SizedBox(height: 1.0),
                      Text(
                        '$formattedDate',
                        style: TextStyle(color: Colors.grey, fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  labelColor: Colors.red[400],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.red[400],
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey,
                  tabs: <Widget>[
                    Tab(child: Text('juice')),
                    Tab(child: Text('smoothie')),
                    Tab(child: Text('shake')),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            JuiceTabContents(),
            SmoothieTabContents(),
            ShakeTabContents(),
          ],
        ),
      ),
    );
  }
}
