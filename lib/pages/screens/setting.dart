import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  var _color = Color(0xFF319B7F);
  Container buildContent(IconData icon, String label, bool isEnd,bool isButton, Color color ){
    return Container(
      color: Colors.white,
//      width: 375,
      height: 48,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left : 17, right : 13, top: 13,bottom: 13),
              child: Icon(icon,color: color),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
//            width: 319,
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: isEnd ? null : Border(bottom: BorderSide(color: Theme.of(context).dividerColor),),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
//                  width: 262,
                      child: Text(label, style: TextStyle(fontFamily: "Roboto",fontSize: 16),),
                    ),
                  ),
                  Container(
                    child: isButton ? IconButton(icon : Icon(Icons.keyboard_arrow_right,color: Colors.grey,),onPressed: () => null,) : null,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "setting",
      home: Scaffold(
        body: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.only(top : 20),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
//                  width: 375,
                  height: 132,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 66,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(19),
                                child: Icon(Icons.location_on,color: Color(0xFF319B7F),size: 33,),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: 230,
                                child: Text("Tracking Lover",
                                  style: TextStyle(
                                      color: Color(0xFF319B7F),fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto"),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(icon: Icon(Icons.help),color: Color(0xFF319B7F),iconSize : 33, onPressed: () => null,),
                            )
                          ],
                        ),
                      ),
                      Container(
//                        width: 375,
                        height: 66,
                        padding: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
                        ),
                        alignment: Alignment.center,
                        child: Text("CÀI ĐẶT",style: TextStyle(fontSize: 34,fontFamily: "Roboto"),),
                      ),

                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 7),
//                  width: 375,
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Icon(Icons.person,color: Color(0xFF319B7F),size: 48,),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
//                          width: 241 ,
                          padding: const EdgeInsets.all(16),
                          child: Column(

                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    child: Text("Bá Anh Bùi",style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 16),),
                                  )
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: const EdgeInsets.all(2),
                                    child: Text("buibaanh0405@gmail.com",style: TextStyle(fontFamily: "Roboto",fontSize: 12),)
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(icon : Icon(Icons.keyboard_arrow_right,color: Colors.grey,),onPressed: () => null,),
                      )
                    ],
                  ),
                ),
                Container(
//                  width: 375,
                  margin: const EdgeInsets.only(top: 7, bottom: 7),
                  child: Column(
                    children: <Widget>[
                      buildContent(Icons.my_location, "Thiết bị",false,true,Color(0xFF319B7F)),
                      buildContent(Icons.lock, "Chính sách riêng tư",false,true,Color(0xFF319B7F)),
                      buildContent(Icons.info_outline, "Thông tin về Tracking Lover",true,true,Color(0xFF319B7F)),
                    ],
                  ),
                ),
                Container(
//                  width: 375,
                  margin: const EdgeInsets.only(top: 7,bottom: 7),
                  child: Column(
                    children: <Widget>[
                      buildContent(Icons.group, "Chuyển tài khoản",false,true,Color(0xFF319B7F)) ,
                      buildContent(Icons.exit_to_app, "Đăng xuất", false, false,Colors.pink)
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

}