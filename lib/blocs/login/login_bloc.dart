import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tracking_app/user_repository/_.dart';

import 'package:tracking_app/blocs/authentication/_.dart';
import 'package:tracking_app/blocs/login/_.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc
  }) :  assert(userRepository != null),
        assert(authenticationBloc != null);
  LoginState get initialState => LoginInitial();
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is LoginButtonPressed){
      yield LoginLoading();
      try{
        final bool token = await userRepository.authenticate(username: event.username, password: event.password);
        if(token){
          authenticationBloc.add(LogIn(token : token));
          yield LoginInitial();
        }
        else{
          yield LoginFailure();
        }
      }
      catch(error){
        yield LoginFailure();
      }
    }
  }
}