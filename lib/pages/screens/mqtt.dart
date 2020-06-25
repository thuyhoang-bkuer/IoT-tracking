import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/mqtt/mqtt_wrapper.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/widgets/common/fade_in.dart';

class MqttForm extends StatefulWidget {
  final Color primaryColor;

  const MqttForm({Key key, this.primaryColor}) : super(key: key);
  @override
  _MqttFormState createState() => _MqttFormState();
}

class _MqttFormState extends State<MqttForm> {
  String _serverUri;
  String _port;
  String _username;
  String _password;
  String _topic;

  @override
  void initState() {
    super.initState();
    // _serverUri = '13.76.250.158';
    // _port = '1883';
    // _topic = 'Topic/GPS';
    // _username = 'BKvm2';
    // _password = 'Hcmut_CSE_2020';
    _serverUri = '52.148.117.13';
    _port = '1883';
    _topic = 'Topic/GPS';
    _username = 'vuong-cuong';
    _password = 'Vuongcuong123';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MqttBloc, MqttState>(
      listener: (context, state) {
        if (state is MqttError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurs. Please try again.'),
            ),
          );
        }
      },
      child: BlocBuilder<MqttBloc, MqttState>(
        builder: (context, state) {
          return AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            duration: Duration(milliseconds: 300),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _buildTitle(context),
                ),
                Expanded(
                  flex: 8,
                  child: FadeIn(
                    delay: 0.5,
                    translateX: false,
                    child: _buildForm(context),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FadeIn(
                    delay: 1.0,
                    translateX: false,
                    child: _buildButton(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildTitle(BuildContext context) {
    return Center(
      child: Text(
        'MQTT Connection',
        style: TextStyle(
          color: Styles.nearlyBlack,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _buildForm(BuildContext context) {
    return BlocBuilder<MqttBloc, MqttState>(
      builder: (context, state) {
        if (state is MqttLoading) {
          return Center(
            child: SpinKitDualRing(
              color: widget.primaryColor,
              size: 48,
            ),
          );
        } else if (state is MqttConnected) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'MQTT Connected',
                    style: TextStyle(
                      color: Styles.greeny,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  size: 128,
                  color: Styles.greeny.withOpacity(0.85),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 8.0, bottom: 8.0),
                        child: TextFormField(
                          initialValue: _serverUri,
                          decoration: InputDecoration(
                            labelText: 'Server Uri',
                            focusColor: widget.primaryColor,
                            prefixIcon: Icon(
                              Icons.layers,
                              size: 24,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => _serverUri = value);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          initialValue: _port,
                          decoration: InputDecoration(
                            labelText: 'Port',
                            focusColor: widget.primaryColor,
                            prefixIcon: Icon(
                              Icons.data_usage,
                              size: 24,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => _port = value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    initialValue: _username,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      focusColor: widget.primaryColor,
                      prefixIcon: Icon(
                        Icons.person_pin,
                        size: 24,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _username = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    initialValue: _password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      focusColor: widget.primaryColor,
                      prefixIcon: Icon(
                        Icons.visibility_off,
                        size: 24,
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() => _password = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    initialValue: _topic,
                    decoration: InputDecoration(
                      labelText: 'Topic',
                      focusColor: widget.primaryColor,
                      prefixIcon: Icon(
                        Icons.collections_bookmark,
                        size: 24,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _topic = value);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _buildButton(BuildContext context) {
    return BlocBuilder<MqttBloc, MqttState>(
      builder: (context, state) {
        if (state is MqttLoading) {
          return Center();
        } else if (state is MqttConnected) {
          return Center(
            child: SizedBox(
              width: 200,
              height: 48,
              child: RaisedButton(
                elevation: 0,
                highlightElevation: 0,
                color: Styles.reddy.withOpacity(0.85),
                highlightColor: Styles.reddy,
                splashColor: Styles.nearlyWhite.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                onPressed: () {
                  BlocProvider.of<MqttBloc>(context).add(MqttPublish(
                    topic: null,
                    payload: {'"action"': '"request/disconnect"'},
                  ));
                  BlocProvider.of<MqttBloc>(context).add(MqttDisconnecting());
                },
                child: Text(
                  'Disconnect',
                  style: TextStyle(
                    color: Styles.nearlyWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }
        return Center(
          child: SizedBox(
            width: 200,
            height: 48,
            child: FlatButton(
              highlightColor: Colors.transparent,
              splashColor: Styles.greeny.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              onPressed: () {
                final payload = {
                  'serverUri': _serverUri,
                  'port': int.parse(_port),
                  'username': _username,
                  'password': _password,
                  'topic': _topic,
                };
                BlocProvider.of<MqttBloc>(context)
                    .add(MqttConnect(topic: null, payload: payload));
              },
              child: Text(
                'Connect',
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
