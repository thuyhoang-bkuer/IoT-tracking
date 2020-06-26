import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:tracking_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/models/enums.dart';
import 'package:tracking_app/mqtt/mqtt_wrapper.dart';
import 'package:tracking_app/pages/screens/mqtt.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/data/device_repository.dart';

import '../data/device_repository.dart';
import '../data/device_repository.dart';
import '../models/privacy.dart';
import '../models/privacy.dart';
import '../models/privacy.dart';
import '../utils/utils.dart';

class TitleBar extends StatefulWidget {
  final Color primaryColor;
  final int pageIndex;
  final bool usedMqtt;

  const TitleBar(
      {Key key, this.primaryColor, this.pageIndex, this.usedMqtt = false})
      : super(key: key);
  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  Widget _buildTitleBar(BuildContext context) {
    if ([0, 1].contains(widget.pageIndex)) {
      return widget.usedMqtt
          ? _buildMqttBar(context)
          : _simulateMqttBar(context);
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Icon(
                Icons.location_on,
                color: widget.primaryColor,
                size: 36,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Tracking Lover",
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.help),
              color: widget.primaryColor,
              iconSize: 36,
              onPressed: () => null,
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      elevation: [0, 1].contains(widget.pageIndex) ? 7.0 : 0.0,
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
        child: _buildTitleBar(context),
      ),
    );
  }

  Widget _buildMqttBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Icon(
              Icons.location_on,
              color: widget.primaryColor,
              size: 36,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            width: 230,
            child: Text(
              "Tracking Lover",
              style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
        BlocBuilder<MqttBloc, MqttState>(
          builder: (context, state) {
            Color color;
            Icon icon;
            String label;

            if (state is MqttConnected) {
              color = Styles.greeny;
              icon = Icon(
                Icons.wifi,
                size: 20,
                color: Styles.greeny,
              );
              label = "On";
            } else {
              color = Styles.reddy;
              icon = Icon(
                Icons.power_settings_new,
                size: 20,
                color: Styles.reddy,
              );
              label = "Off";
            }

            return Expanded(
              flex: 2,
              child: ActionChip(
                backgroundColor: color,
                elevation: 1,
                pressElevation: 0,
                onPressed: () {
                  if (state is MqttUnitial) {
                    BlocProvider.of<MqttBloc>(context).add(
                      MqttInitialize(
                        new MqttClientWrapper(onDisconnectedCallback: () {
                          BlocProvider.of<MqttBloc>(context)
                              .add(MqttDisconnected());
                        }, onDataReceivedCallback: (data) async {
<<<<<<< HEAD
                          Map valueMap = json.decode(data);
                          final jsonData = await rootBundle
                              .loadString('assets/storage/district10.json');
                          final jsonMap = json.decode(jsonData);
                          var polygon = jsonMap['points'];

                          double latitude = double.parse(valueMap['values'][0]);
                          double longitude =
                              double.parse(valueMap['values'][1]);
                          List<double> point = [latitude, longitude];
                          bool isInside =
                              Utils.isInside(polygon, polygon.length, point);

                          if (isInside) {
                            BlocProvider.of<MqttBloc>(context).add(
                                MqttPublish(topic: "Topic/LightD", payload: {
                              "device_id": "LightD",
                              "values": ["0", "0"]
                            }));
                          } else {
                            BlocProvider.of<MqttBloc>(context).add(
                                MqttPublish(topic: "Topic/LightD", payload: {
                              "device_id": "LightD",
                              "values": ["1", "255"]
                            }));
                          }
                        }),
                      ),
                    );
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        content: MqttForm(primaryColor: Styles.greeny),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      );
                    },
                  );
                },
                avatar: CircleAvatar(
                  child: icon,
                  backgroundColor: Styles.nearlyWhite,
                ),
                label: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Styles.nearlyWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                shadowColor: color,
              ),
            );
          },
        )
      ],
    );
  }

  Widget _simulateMqttBar(BuildContext context) {
    final devices = BlocProvider.of<DeviceBloc>(context).state.devices;
    final random = Random();

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Icon(
              Icons.location_on,
              color: widget.primaryColor,
              size: 36,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            width: 230,
            child: Text(
              "Tracking Lover",
              style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.transparent,
            splashColor: Styles.blueky.withOpacity(0.15),
            highlightElevation: 0,
            elevation: 0,
            onPressed: () =>
                BlocProvider.of<DeviceBloc>(context).add(FetchDevices()),
            child: Icon(
              Icons.wifi,
              size: 24,
            ),
            foregroundColor: Styles.blueky,
          ),
        ),
        Expanded(
          flex: 1,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.transparent,
            splashColor: Styles.blueky.withOpacity(0.15),
            highlightElevation: 0,
            elevation: 0,
            onPressed: () {
              final id = random.nextInt(devices.length);
              final device = devices[id];
              final payload = {
                "index": id,
                "deviceId": device.id,
                "latitude": (random.nextDouble() - 0.5) * 0.003 +
                    device.position.latitude,
                "longitude": (random.nextDouble() - 0.5) * 0.003 +
                    device.position.longitude,
              };
              BlocProvider.of<DeviceBloc>(context).add(
                SubcribePosition(payload: payload),
              );
            },
            child: Icon(
              Icons.gps_fixed,
              size: 24,
            ),
            foregroundColor: Styles.blueky,
          ),
        ),
      ],
    );
  }
}
