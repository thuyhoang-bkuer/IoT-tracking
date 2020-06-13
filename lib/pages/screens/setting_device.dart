import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:tracking_app/pages/screens/setting.dart';

class SettingDevice extends StatefulWidget {
  @override
  _SettingDeviceState createState() => _SettingDeviceState();
}

class _SettingDeviceState extends State<SettingDevice> {
    @override
  Container buildContent(String label, bool isUsing) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border:  Border(top: BorderSide(color: Theme.of(context).dividerColor),),
        color: Colors.white
      ),

      child: ListTile(
        leading: Icon(Icons.gps_fixed,color: isUsing ? Color(0xFF319B7F) : Colors.grey,),
        title: Text(label, style: TextStyle(
            fontSize: 16,
            fontFamily: "Roboto"
        ),),
        trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => null)),),
      ),
    );
  }
  List deviceAvailable = [
    ["ABC",false,SettingScreen()],
    ["ABC",false,SettingScreen()],
    ["ABC",false,SettingScreen()]
  ];
  List deviceConnected = [
    ["ABC",true,SettingScreen()],
    ["ABC",false,SettingScreen()],
  ];
    Widget getTextWidgets(List device)
    {
      return new Column(children: device.map((item) => buildContent(item[0],item[1])).toList());
    }
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.only(top : 20),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
//                  width: 375,
//                  height: 140,
                child: Column(
                  children: <Widget>[
                    Container(
//                        width: 375,
                        height: 64,
                        margin: const EdgeInsets.only(top : 20),
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
                        ),
//                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: IconButton(icon: Icon(Icons.keyboard_arrow_left,size: 30,),
                                  onPressed: () => Navigator.pop(context, MaterialPageRoute(builder: (context) => SettingScreen())),),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Thiết bị",
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
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: Container(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                "Kết nối thiết bị",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Roboto"
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              child: CustomSwitch(
                                activeColor: Color(0xFF319B7F),
                                value: false,
                                onChanged: (value) {
                                  print("VALUE : $value");
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 7),
                  color: Colors.white,
                  child: ListView(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 20,bottom: 20),
                          child: Text("ĐÃ KẾT NỐI",style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
                          ),),
                        ),
                        getTextWidgets(deviceConnected)
                      ]
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 7),
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 20,bottom: 20),
                        child: Text("HIỆN CÓ",style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                        ),),
                      ),
                      getTextWidgets(deviceAvailable)
//                        buildContent("CAC",false),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}