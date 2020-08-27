/* * This file/screen is what provides the structure for the three tabs (juice,
 * smoothie, and shake). It also displays the date in the top of the screen tog-
 * ether with the text - Today.
 */

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
  final String _today = "Today";

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM').format(now).toUpperCase();

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
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 10.0, top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$_today',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Product Sans',
                              fontSize: 32.0),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        Text(
                          '$formattedDate',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          ),
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
                      Tab(
                        child: Text(
                          'juice',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'smoothie',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'shake',
                        ),
                      ),
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
              ShakeTabContents()
            ],
          )),
    );
  }
}
