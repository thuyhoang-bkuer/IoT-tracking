import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tracking_app/styles/index.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _loginContainer = Container();

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xFF226C58),
            Color(0xFF319B7F),
            Color(0xC0A13E56)
          ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            // child: Image.asset(
            //   'assets/images/logo.png',
            //   width: 128,
            //   height: 128,
            // ),
          ),
          Container(
            height: 64,
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "iTracking",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                color: Styles.nearlyWhite.withAlpha(192),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Colors.white.withAlpha(80)),
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.transparent),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.email,
                            color: Styles.nearlyWhite,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(right: 16),
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(color: Styles.nearlyWhite)),
                    style: TextStyle(color: Styles.nearlyWhite),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Colors.white.withAlpha(80)),
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.transparent),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.lock,
                            color: Styles.nearlyWhite,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(right: 16),
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(color: Styles.nearlyWhite)),
                    style: TextStyle(color: Styles.nearlyWhite),
                    obscureText: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Colors.white.withAlpha(80)),
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.transparent),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.lock,
                            color: Styles.nearlyWhite,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(right: 16),
                        border: InputBorder.none,
                        hintText: "Confirm password",
                        hintStyle: TextStyle(color: Styles.nearlyWhite)),
                    style: TextStyle(color: Styles.nearlyWhite),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: RaisedButton(
                      splashColor: Color(0x11226C58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      color: Styles.nearlyWhite.withAlpha(192),
                      child: Text(
                        "Sign Up",
                        style:
                            TextStyle(color: Color(0xFF226C58), fontSize: 18),
                      ),
                      onPressed: () => null,
                    ),
                  ),
                ),
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Styles.nearlyWhite),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlineButton(
                      splashColor: Styles.nearlyWhite.withAlpha(40),
                      borderSide: BorderSide(
                        color: Styles.nearlyWhite.withAlpha(192),
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Text(
                        "Sign In",
                        style:
                            TextStyle(color: Styles.nearlyWhite, fontSize: 18),
                      ),
                      onPressed: () => null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
