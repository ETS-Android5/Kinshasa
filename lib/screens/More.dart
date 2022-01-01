import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kinshasa/shared/exports.dart';


class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  static FavoritesBloc _favoritesBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favoritesBloc = Provider.of<FavoritesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'More',
          style: TextStyle(color: Colors.black, fontFamily: 'Product Sans'),
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
                applicationName: 'Fruit Zilla',
                applicationVersion: '1.0',
                applicationLegalese:
                    'A drink (juice, smoothie, shake) recipe app',
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
            future: SharedPreferencesHelper.getDeleteConfirmationPreference(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListTile(
                  title: Text('Confirm before deleting'),
                  leading: Icon(CupertinoIcons.delete),
                  trailing: Switch(
                    value: snapshot.data,
                    onChanged: (value) {
                      _favoritesBloc.setDeletePreference(value);
                      SharedPreferencesHelper.setConfirmDelete(value);
                    },
                  ),
                );
              }
              return ListTile();
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

    Utils.showToast('!', platformResponse);
  }
}
