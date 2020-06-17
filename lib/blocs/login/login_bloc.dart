import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/data/_.dart';

part 'login_events.dart';
part 'login_states.dart';

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
        final bool token = await userRepository.authenticate(email: event.username, password: event.password);
        if(token){
          authenticationBloc.add(LogIn(token : token));
          yield LoginInitial();
        }
        else{
          yield LoginFailure(error: 'Wrong username or password!');
        }
      }
      catch(error){
        yield LoginFailure(error: 'An error occurs!');
      }
    }
  }
}