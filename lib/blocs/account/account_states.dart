part of 'account_bloc.dart';

abstract class AccountState extends Equatable{
  final String email;
  final String username;
  const AccountState(this.email, this.username);
}
class UnAuthentication extends AccountState{
  const UnAuthentication(String email, String username) : super(email,username);
  @override
  List<Object> get props => [super.email,super.username];
}

class Initial extends AccountState {
  const Initial(String email, String username) : super(email,username);
  @override
  List<Object> get props => [this.email,this.username];
  String toString() => 'Initial {email : $email, username : $username}';
}

class Updated extends AccountState{
  const Updated(String email, String username) : super(email,username);
  @override
  List<Object> get props => [super.email,super.username];
}
class AccountError extends AccountState {
  final String error;
  const AccountError({this.error}) : super("","");
  @override
  List<Object> get props => [error];
}
