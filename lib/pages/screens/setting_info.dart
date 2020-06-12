import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/pages/screens/setting.dart';

class SettingInfo extends StatefulWidget {
  @override
  _SettingInfoState createState() => _SettingInfoState();
}

class _SettingInfoState extends State<SettingInfo> {
  @override
  Container buildContent(String label, bool isEnd, Color color) {
    return Container(
        color: Colors.white,
//      width: 375,
        height: 48,
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
              color: Colors.white),
          child: ListTile(
            title: Text(
              label,
              style:
                  TextStyle(fontSize: 16, fontFamily: "Roboto", color: color),
            ),
          ),
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.only(top: 20),
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
                      height: 64,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(bottom: 20),
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
                                    builder: (context) => SettingScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Thông tin về Tracking Lover",
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
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).dividerColor)),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 66,
                          color: Color(0xFF319B7F),
                        ),
                        Text(
                          "Tracking Lover",
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
//                  width: 375,
              child: Column(
                children: <Widget>[
                  buildContent(
                      "Phiên bản : 1.0.1", false, Color.fromRGBO(0, 0, 0, 0.6)),
                  buildContent("Kiểm tra cập nhật ", false,
                      Color.fromRGBO(0, 0, 0, 0.87)),
                  buildContent("Tính năng & Hướng dẫn ", false,
                      Color.fromRGBO(0, 0, 0, 0.87)),
                  buildContent("Điều khoản sử dụng", true,
                      Color.fromRGBO(0, 0, 0, 0.87)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Phát triển bởi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "RLoVP Team",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
