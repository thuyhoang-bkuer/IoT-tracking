import 'dart:async';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:password/password.dart';

// Please refer to `device_repository.dart`
// We need an abstract class then implementing it
// in different version to test in local and remote
// Moreover, we use HTTP requests to retrive data
// from remote server instead of mimics a DataLayer's behavior.
class NetworkErr extends Error {}

class UserRepository {
  final String baseUrl = "http://192.168.1.68:3000/";
  Future<bool> authenticate({
    @required String email,
    @required String password,
  }) async {
    final url = baseUrl + 'user/$email';
    final headers = {"Content-type": "application/json"};
    final response = await get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jLog = json.decode(response.body);
        // print(Password.hash(password, new PBKDF2()));
        if (jLog.length == 0) {
          return false;
        }
        if (password == "" || email == "") return false;
        if ((jLog[0]["email"] == email)) {
          return Future.sync(
              () => Password.verify(password, jLog[0]["password"]));
        } else
          return false;
      } else
        throw NetworkErr();
    } on Error {
      throw Error;
    }
  }

  Future<void> persistToken() async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<List<String>> getInfoUser({@required String email}) async {
    final url = baseUrl + 'user/$email';
    final headers = {"Content-type": "application/json"};
    final response = await get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jLog = json.decode(response.body);
        if ((jLog[0]["email"] == email)) {
          return [jLog[0]["email"], jLog[0]["email"]];
        } else
          return ["cac", "cac"];
      } else
        throw NetworkErr();
    } on Error {
      throw Error;
    }
  }
}
