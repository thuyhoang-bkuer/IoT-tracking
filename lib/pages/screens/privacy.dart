import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/pages/screens/devices.dart';
import 'package:tracking_app/styles/index.dart';

class PrivacyScreen extends StatefulWidget {
  final Color primaryColor = Styles.greeny;
  final String deviceId;

  const PrivacyScreen({Key key, this.deviceId}) : super(key: key);
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _addEnable;

  @override
  void initState() {
    super.initState();
    _addEnable = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrivacyBloc, PrivacyState>(
      listener: (context, state) {},
      child: BlocBuilder<PrivacyBloc, PrivacyState>(
        builder: (context, state) {
          if (state is PrivacyLoading) {
            return loadingView(context, state);
          } else if (state is PrivacyLoaded) {
            return loadedView(context, state);
          }
          return initialView(context, state);
        },
      ),
    );
  }

  Widget _buildNavigateBar(BuildContext context, PrivacyState state) {
    bool reloading = false;
    if (state is PrivacyLoading) reloading = true;
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.deviceId}",
              style: TextStyle(
                  color: Styles.nearlyBlack,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              splashColor: Styles.greeny.withOpacity(0.15),
              highlightElevation: 0,
              elevation: 0,
              onPressed: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                size: 24,
              ),
              foregroundColor: Styles.greeny,
            ),
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              splashColor: Styles.greeny.withOpacity(0.15),
              highlightElevation: 0,
              elevation: 0,
              onPressed: reloading
                  ? null
                  : () {
                      BlocProvider.of<PrivacyBloc>(context).add(
                        FetchPrivacy(null, {"deviceId": state.deviceId}),
                      );
                    },
              child: Icon(
                Icons.refresh,
                size: 24,
              ),
              foregroundColor: Styles.greeny,
            ),
          ],
        ),
      ],
    );
  }

  Widget initialView(BuildContext context, PrivacyState state) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: _buildNavigateBar(context, state),
      ),
      body: Center(
        child: Icon(
          Icons.portable_wifi_off,
          size: 128,
          color: Styles.deactivatedText,
        ),
      ),
    );
  }

  Widget loadingView(BuildContext context, PrivacyState state) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: _buildNavigateBar(context, state),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SpinKitChasingDots(
                color: widget.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadedView(BuildContext context, PrivacyLoaded state) {
    return !_addEnable
        ? Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: _buildNavigateBar(context, state),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: List.generate(
                      state.policies.length,
                      (i) => Slidable(
                        key: Key('dismiss_$i'),
                        actionPane: SlidableDrawerActionPane(),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => null,
                          ),
                        ],
                        child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.timer,
                                  size: 24,
                                  color: widget.primaryColor,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: Text(
                                    DateFormat('HH:mm - dd/MM/yyyy').format(
                                      state.policies[i].timeStart,
                                    ),
                                    style: TextStyle(
                                      color: Styles.nearlyBlack,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 24,
                                  color: widget.primaryColor,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: Text(
                                    DateFormat('HH:mm - dd/MM/yyyy').format(
                                      state.policies[i].timeEnd,
                                    ),
                                    style: TextStyle(
                                      color: Styles.nearlyBlack,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.timer,
                                  size: 24,
                                  color: widget.primaryColor,
                                ),
                              ),
                              Expanded(
                                flex: 11,
                                child: Text(
                                  state.policies[i].placement,
                                  style: TextStyle(
                                    color: Styles.nearlyBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () => setState(() => _addEnable = true),
                elevation: 1,
                focusElevation: 0,
                highlightElevation: 0,
                backgroundColor: widget.primaryColor,
                child: Icon(
                  Icons.add,
                  size: 24,
                  color: Styles.nearlyWhite,
                ),
                splashColor: widget.primaryColor,
              ),
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: _buildNavigateBar(context, state),
            ),
            body: ListView(
              children: List.generate(
                state.policies.length,
                (i) => Slidable(
                  key: Key('dismiss_$i'),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => null,
                    ),
                  ],
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.timer,
                            size: 24,
                            color: widget.primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Text(
                              DateFormat('HH:mm - dd/MM/yyyy').format(
                                state.policies[i].timeStart,
                              ),
                              style: TextStyle(
                                color: Styles.nearlyBlack,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 24,
                            color: widget.primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Text(
                              DateFormat('HH:mm - dd/MM/yyyy').format(
                                state.policies[i].timeStart,
                              ),
                              style: TextStyle(
                                color: Styles.nearlyBlack,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.timer,
                            size: 24,
                            color: widget.primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 11,
                          child: Text(
                            state.policies[i].placement,
                            style: TextStyle(
                              color: Styles.nearlyBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () => setState(() => _addEnable = false),
                elevation: 1,
                focusElevation: 0,
                highlightElevation: 0,
                backgroundColor: widget.primaryColor,
                child: Icon(
                  Icons.close,
                  size: 24,
                  color: Styles.nearlyWhite,
                ),
                splashColor: widget.primaryColor,
              ),
            ),
          );
  }
}
