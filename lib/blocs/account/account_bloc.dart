import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tracking_app/data/_.dart';

part 'account_states.dart';
part 'account_events.dart';

class AccountBloc extends Bloc<AccountEvent,AccountState>{
  final UserRepository userRepository;
  AccountBloc({
    @required this.userRepository
  }) :assert(userRepository != null);
  @override
  AccountState get initialState => UnAuthentication("","");
  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async*{
    if(event is LogInAccount){
      try{
        final info = await userRepository.getInfoUser(email: event.email);
        yield Initial(info[0], info[1]);
      }
      catch(error){
        yield AccountError(error: error);
      }
    }
    if(event is UpdateAccount){
      try{
        final info = await userRepository.getInfoUser(email: event.email);
        yield Updated(info[0], info[1]);
      }
      catch(error){
        yield AccountError(error: error);
      }
    }
  }
}