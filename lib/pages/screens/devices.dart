import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/widgets/sliding_card.dart';
import 'package:tracking_app/widgets/title_bar.dart';

class DeviceScreen extends StatefulWidget {
  final Color primaryColor;

  const DeviceScreen({Key key, this.primaryColor}) : super(key: key);

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TitleBar(
          primaryColor: widget.primaryColor,
          pageIndex: 0,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeviceBloc, DeviceState>(
            listener: (context, state) {
              if (state is DeviceError) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
        child: Container(
          child: BlocBuilder<DeviceBloc, DeviceState>(
            builder: (context, state) {
              if (state is DeviceInitial) {
                return _initialView(context, state);
              } else if (state is DeviceLoading) {
                return _loadingView(context, state);
              } else if (state is DeviceLoaded) {
                return _loadedView(context, state);
              } else if (state is DeviceError) {
                return _initialView(context, state);
              } else {
                throw Error();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _initialView(BuildContext context, DeviceState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Icon(
            Icons.phonelink_off,
            size: 128,
            color: Styles.grey,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "No Devices",
              style: TextStyle(
                fontSize: 24,
                color: Styles.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _loadingView(BuildContext context, DeviceState state) {
    return Center(child: SpinKitPumpingHeart(color: widget.primaryColor));
  }

  Widget _loadedView(BuildContext context, DeviceState state) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Devices",
                  style: TextStyle(
                    color: widget.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.devices.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: SlidingCard(
                    index: index, primaryColor: widget.primaryColor),
              );
            },
          ),
        ],
      ),
    );
  }
}
