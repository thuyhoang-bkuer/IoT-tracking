import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable{
  const AuthenticationEvent();
  List<Object> get props => [];
}
class AppStart extends AuthenticationEvent{

}

class LogIn extends AuthenticationEvent{
  final bool token;
  const LogIn({@required this.token});
  @override
  List<Object> get props => [token];
  @override
  String toString() => 'LoggedIn {token : $token}';
}

class LogOut extends AuthenticationEvent{

}