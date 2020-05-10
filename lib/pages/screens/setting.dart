import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Container buildContent(IconData icon, String label, bool isEnd){
    return Container(
      color: Colors.white,
      width: 375,
      height: 48,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left : 17, right : 13, top: 13,bottom: 13),
            child: Icon(icon,color: Color(0xFF319B7F)),
          ),
          Container(
            width: 319,
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: isEnd ? null : Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 262,
                  child: Text(label, style: TextStyle(fontFamily: "Roboto",fontSize: 16),),
                ),
                Container(
                  child: IconButton(icon : Icon(Icons.keyboard_arrow_right,color: Colors.grey,),onPressed: () => null,),
                )
              ],
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
                  width: 375,
                  height: 132,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 66,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(19),
                              child: Icon(Icons.location_on,color: Color(0xFF319B7F),size: 33,),
                            ),
                            Container(
                              width: 230,
                              child: Text("Tracking Lover",
                                style: TextStyle(
                                    color: Color(0xFF319B7F),fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto"),),
                            ),

                            IconButton(icon: Icon(Icons.help),color: Color(0xFF319B7F),iconSize : 33, onPressed: () => null,)
                          ],
                        ),
                      ),
                      Container(
                        width: 375,
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
                  width: 375,
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Icon(Icons.person,color: Color(0xFF319B7F),size: 48,),
                      ),
                      Container(
                        width: 241 ,
                        padding: const EdgeInsets.only(top: 16,bottom: 16),
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
                      IconButton(icon : Icon(Icons.keyboard_arrow_right,color: Colors.grey,),onPressed: () => null,)
                    ],
                  ),
                ),
                Container(
                  width: 375,
                  height: 10,
                ),
                buildContent(Icons.my_location, "Thiết bị",false),
                buildContent(Icons.lock, "Chính sách riêng tư",false),
                buildContent(Icons.info_outline, "Thông tin về Tracking Lover",true),
                Container(
                  width: 375,
                  height: 10,
                ),
                buildContent(Icons.group, "Chuyển tài khoản",false) ,
                Container(
                  color: Colors.white,
                  width: 375,
                  height: 48,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left : 17, right : 13, top: 13,bottom: 13),
                        child: Icon(Icons.exit_to_app,color: Colors.pink),
                      ),
                      Container(
                        width: 319,
                        height: 48,
                        padding: const EdgeInsets.all(4),

                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 262,
                              child: Text("Đăng xuất", style: TextStyle(fontFamily: "Roboto",fontSize: 16),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

}