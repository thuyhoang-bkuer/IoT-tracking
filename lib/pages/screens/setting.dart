import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/blocs/authentication/_.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: RaisedButton(
              child: Text('logout'),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
              },
            )),
      ),
    );
  }
}