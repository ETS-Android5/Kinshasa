/* *This file/screen is the last of the four tabs the user sees when the app
 * launches. It serves as a kind of settings screen for the app. The contents of 
 * this screen are explained below:
 * • About: this tile when clicked shows a little information about the app
 * • Rate the app
 * • Share the app
 * • Help and feedback: when clicked, it launches the mail app of the user so that
 *      he can send a mail to the developer
 * • Confirm before deleting
 * • Exit: exits the app when clicked.
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kinshasa/widgets/FavoritesProvider.dart';
import 'package:kinshasa/widgets/SharedPreferencesHelper.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final TextStyle _style =
      TextStyle(color: Colors.black, fontFamily: 'Product Sans');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static FavoritesBloc _favoritesBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favoritesBloc = Provider.of<FavoritesBloc>(context);
  }

// This is the method that launches the user's mail app and prepares it for send-
// a mail to the developer
  Future<void> send() async {
    final Email email = Email(
      body: '',
      subject: 'Help, feedback',
      recipients: ['27umbrellas@gmail.com'],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Thanks for the feedback!';
    } catch (error) {
      platformResponse = error.toString();
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'More',
          style: _style,
        ),
      ),
      body: ListView(
        children: <Widget>[
          // About
          ListTile(
            title: Text('About'),
            leading: Icon(LineAwesomeIcons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Succo Drink App',
                applicationVersion: '1.0',
                applicationLegalese: 'This is a recipe app',
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(),
          ),

          // Rate the app
          ListTile(
            leading: Icon(LineAwesomeIcons.star_o),
            title: Text('Rate the app'),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(),
          ),

          // Share the app
          ListTile(
            leading: Icon(LineAwesomeIcons.share_alt_square),
            title: Text('Share the app'),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(),
          ),

          // Help and feedback
          ListTile(
              title: Text('Help and Feedback'),
              leading: Icon(LineAwesomeIcons.send_o),
              onTap: send),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(),
          ),

          // Confirm before delete
          FutureBuilder(
            future: SharedPreferencesHelper.getConfirmDelete(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text('Confirm before deleting'),
                leading: Icon(Icons.warning),
                trailing: Checkbox(
                  value: snapshot.data,
                  onChanged: (value) {
                    SharedPreferencesHelper.setConfirmDelete(value);
                    _favoritesBloc.setDeletePreference(value);
                    setState(() {});
                  },
                ),
                onTap: () {},
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(),
          ),

          // Exit
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              SystemNavigator.pop();
              Future.delayed(const Duration(milliseconds: 500), () {
                exit(0);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
