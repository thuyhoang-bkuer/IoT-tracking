part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable{
  const AccountEvent();
  List<Object> get props => [];
}

class LogInAccount extends AccountEvent{
  final String email;
  const LogInAccount({@required this.email});
  @override
  List<Object> get props => [email];
}

class UpdateAccount extends AccountEvent{
  final String email;
  const UpdateAccount({@required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() =>
      'Account Info { username: $email }';
}