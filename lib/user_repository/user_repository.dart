import 'dart:async';
import 'package:meta/meta.dart';
import 'package:mongo_dart/mongo_dart.dart';
class UserRepository {
  Future<bool> authenticate({
    @required String username,
    @required String password
  })async {
    //access database to check account exist or not
    await Future.delayed(Duration(seconds: 1));
    Db db = Db("mongodb://10.0.2.2:27017/models");
    await db.open();
    var coll = db.collection('User');
    var people = await coll.find({"password":password,"email" : username}).toList();
    if(people.length == 0){
      return false;
    }
    else{
      return true;
    }
  }
  Future<void> persistToken() async{
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}