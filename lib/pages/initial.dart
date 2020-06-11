import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tracking_app/pages/_.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/user_repository/_.dart';

import 'package:tracking_app/blocs/authentication/_.dart';
import 'package:tracking_app/pages/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tracking_app/pages/loading.dart';
import 'package:loading_animations/loading_animations.dart';


class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SignInPage(userRepository: userRepository);
          }
          if (state is AuthenticationAuthenticated) {
            return HomePage();
          }
          if (state is AuthenticationUnauthenticated) {
//            return LoginPage(userRepository: userRepository);
              return SignInPage(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF226C58), Color(0xFF319B7F), Color(0xC0A13E56)],
                ),
              ),
              child: SpinKitPouringHourglass(
                duration: const Duration(milliseconds: 1500),
                size: 100,
                color: Colors.white70,
              ),
            );
          }
        },
      ),
    );
  }
}