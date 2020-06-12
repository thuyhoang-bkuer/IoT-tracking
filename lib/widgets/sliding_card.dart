import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/pages/screens/privacy.dart';
import 'package:tracking_app/styles/index.dart';

class SlidingCard extends StatefulWidget {
  final int index;
  final Color primaryColor;

  const SlidingCard({Key key, this.index, this.primaryColor}) : super(key: key);

  @override
  _SlidingCardState createState() => _SlidingCardState();
}

class _SlidingCardState extends State<SlidingCard> {
  bool isBusy;

  @override
  void initState() {
    super.initState();
    isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // void slidingHandle(double value) {
    //   setState(() {
    //     isBusy = true;
    //   });
    //   setState(() {
    //     slidedValue = value;
    //     slidedWidth = Styles.boxWidth +
    //         slidedValue * (width - Styles.sidePadding * 4 - Styles.boxWidth);
    //   });
    //   setState(() {
    //     isBusy = false;
    //   });
    // }

    switchHandle(bool value) {
      final payload = {"id": widget.index, "status": value};

      BlocProvider.of<DeviceBloc>(context).add(PutDevice(payload: payload));
    }

    double slideWidth(bool isEnable) => isEnable ? width : 100.0;

    Widget _sliderAnimation(BuildContext context, DeviceState state) {
      return Stack(
        children: <Widget>[
          AnimatedContainer(
            width: width - 2 * Styles.sidePadding,
            height: Styles.boxHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              boxShadow: state.devices[widget.index].status == Power.On
                  ? [
                      BoxShadow(
                        color: widget.primaryColor.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
            ),
            duration: Duration(milliseconds: 300),
          ),
          IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                curve: Curves.easeInOutQuart,
                duration: Duration(
                  milliseconds: isBusy ? 0 : 500,
                ),
                width:
                    slideWidth(state.devices[widget.index].status == Power.On),
                height: Styles.boxHeight,
                decoration: BoxDecoration(
                  color: state.devices[widget.index].status == Power.On
                      ? widget.primaryColor.withOpacity(0.65)
                      : widget.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Widget _sliderValue = IgnorePointer(
    //   ignoring: state.getDevices[widget.index] == false,
    //   child: SliderTheme(
    //     data: SliderThemeData(
    //       trackHeight: Styles.trackHeight,
    //       overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.only(
    //         left: 100.0,
    //         right: 80.0,
    //       ),
    //       child: Slider(
    //         activeColor: Colors.transparent,
    //         inactiveColor: Colors.transparent,
    //         value: slidedValue,
    //         onChanged: slidingHandle,
    //       ),
    //     ),
    //   ),
    // );

    Widget _sliderContent(BuildContext context, DeviceState state) {
      return IgnorePointer(
        ignoring: state.devices[widget.index].status == Power.Off,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    height: 100,
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.place,
                          color: Styles.darkText,
                          size: 36,
                        ),
                        Text(
                          state.devices[widget.index].status == Power.On
                              ? 'On'
                              : 'Off',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Sf',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          BlocProvider.of<PrivacyBloc>(context).add(
                            FetchPrivacy(
                              null,
                              {'deviceId': state.devices[widget.index].id},
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyScreen(
                                deviceId: '${state.devices[widget.index].name}',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          state.devices[widget.index].name,
                          style: TextStyle(
                            color: Styles.nearlyBlack,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        state.devices[widget.index].id.toString(),
                        style: TextStyle(
                          color: Styles.nearlyBlack,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget _cupertinoSwitch(BuildContext context, DeviceState state) {
      return Container(
        width: Styles.boxWidth,
        height: Styles.boxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: CupertinoSwitch(
          activeColor: widget.primaryColor,
          value: state.devices[widget.index].status == Power.On,
          onChanged: switchHandle,
        ),
      );
    }

    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            _sliderAnimation(context, state),
            // _sliderValue,
            _sliderContent(context, state),
            _cupertinoSwitch(context, state)
          ],
        );
      },
    );
  }
}
