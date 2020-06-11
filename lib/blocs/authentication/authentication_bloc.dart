import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tracking_app/user_repository/user_repository.dart';
import 'package:tracking_app/blocs/authentication/_.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent,AuthenticationState>{
  final UserRepository userRepository;
  AuthenticationBloc({
    @required this.userRepository
  }) :assert(userRepository != null);
  @override
  AuthenticationState get initialState => AuthenticationUnauthenticated();
  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async*{
    if(event is AppStart){
      await userRepository.persistToken();
      yield AuthenticationUnauthenticated();
    }
    if(event is LogIn){
      yield AuthenticationLoading();
      await userRepository.persistToken();
      yield AuthenticationAuthenticated();
    }
    if(event is LogOut){
      yield AuthenticationLoading();
      await userRepository.persistToken();
      yield AuthenticationUnauthenticated();
    }
  }
}