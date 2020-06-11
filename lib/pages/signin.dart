import 'dart:ffi';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/pages/_.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/user_repository/_.dart';
import 'package:tracking_app/blocs/authentication/_.dart';
import 'package:tracking_app/blocs/login/_.dart';

class SignInPage extends StatefulWidget {
  final UserRepository userRepository;

  SignInPage({Key key,@required this.userRepository})
      : assert(userRepository != null),
        super(key:key);
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
//  final UserRepository userRepository;
//  SignInPageState({this.userRepository});
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
    return MaterialApp(
      title: 'iTracking',
      theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: Styles.textTheme
      ),
      home: LoginPage(userRepository: widget.userRepository),
    );
  }
}

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}


