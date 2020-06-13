import 'dart:async';
import 'package:meta/meta.dart';

// Please refer to `device_repository.dart`
// We need an abstract class then implementing it
// in different version to test in local and remote
// Moreover, we use HTTP requests to retrive data 
// from remote server instead of mimics a DataLayer's behavior.
class UserRepository {
  Future<bool> authenticate({
    @required String username,
    @required String password
  })async {

    // TODO: Please fix this using http request
    
    // //access database to check account exist or not
    // await Future.delayed(Duration(seconds: 1));
    // Db db = Db("mongodb://10.0.2.2:27017/models");
    // await db.open();
    // var coll = db.collection('User');
    // var people = await coll.find({"password":password,"email" : username}).toList();
    // if(people.length == 0){
    //   return false;
    // }
    // else{
    //   return true;
    // }
  }
  Future<void> persistToken() async{
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}