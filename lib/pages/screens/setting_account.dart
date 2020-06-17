import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/pages/screens/setting.dart';

class SettingAccount extends StatefulWidget {
  @override
  _SettingAccountState createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  @override
  String name_user = "BÁ ANH";
  String user_email = "buibaanh0405@gmail.com";
  String name;
  String email;
  String password;
  String re_pw;
  bool _obscure = true;
  bool __obscure = true;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
//                  width: 375,
//                  height: 132,
                  child: Column(
                    children: <Widget>[
                      Container(
//                        width: 375,
                          height: 56,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).dividerColor)),
                          ),
//                        alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_left,
                                      size: 30,
                                    ),
                                    onPressed: () => Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingScreen())),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Thông tin tài khoản",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              )
                            ],
                          )),
                      Container(
//                        width: 375,
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor)),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 66,
                              color: Color(0xFF319B7F),
                            ),
                            Text(
                              name_user,
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.person),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      "Tên tài khoản",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "Roboto"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey)),
                                      border: OutlineInputBorder()),
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.email),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "Roboto"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey)),
                                      border: OutlineInputBorder()),
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.vpn_key),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      "Mật khẩu mới",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "Roboto"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: TextField(
                                  obscureText: _obscure,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _obscure = !_obscure;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey)),
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.vpn_key),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      "Nhập lại mật khẩu mới",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "Roboto"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: TextField(
                                  obscureText: __obscure,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(__obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          __obscure = !__obscure;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      re_pw = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: MaterialButton(
                      minWidth: 300,
                      height: 40,
                      color: Color(0xFF319B7F),
                      child: Text(
                        "Cập nhật thông tin",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        print(name);
                        print(email);
                        print(password);
                      },
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}