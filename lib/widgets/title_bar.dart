import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/styles/index.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 7.0,
      child: Padding(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Tracking Lover",
                  style: TextStyle(
                      color: Styles.greeny,
                      fontSize: 27,
                      fontWeight: FontWeight.w500),
                )),
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              splashColor: Styles.blueky.withOpacity(0.15),
              highlightElevation: 0,
              elevation: 0,
              onPressed: () => BlocProvider.of<DeviceBloc>(context).add(FetchDevices()),
              child: Icon(
                Icons.wifi,
                size: 24,
              ),
              foregroundColor: Styles.blueky,
            )
          ],
        ),
      ),
    );
  }
}
