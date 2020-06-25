import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/widgets/common/fade_in.dart';

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
      listener: (context, state) {
        if (state is PrivacyError) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
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
                fontWeight: FontWeight.w500,
              ),
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
    if (!_addEnable) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: _buildNavigateBar(context, state),
        ),
        body: state.policies.length == 0
            ? _emptyPrivacyBoard(context, state)
            : _privacyBoard(context, state),
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
      );
    } else {
      return PrivacyForm(
        deviceId: state.deviceId,
        primaryColor: widget.primaryColor,
        fabHandler: () {
          setState(() => _addEnable = false);
        },
      );
    }
  }

  Widget _emptyPrivacyBoard(BuildContext context, PrivacyLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Icon(
            Icons.alarm_off,
            size: 128,
            color: Styles.deactivatedText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Click + to add new privacy',
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  Widget _privacyBoard(BuildContext context, PrivacyLoaded state) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: List.generate(
                state.policies.length,
                (i) => FadeIn(
                  delay: i * 0.4,
                  child: Slidable(
                    key: Key('dismiss_$i'),
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          final privacy = state.policies[i];
                          final payload = {
                            'deviceId': state.deviceId,
                            '_id': privacy.id,
                          };
                          BlocProvider.of<PrivacyBloc>(context)
                              .add(RemovePrivacy(null, payload));
                        },
                      ),
                    ],
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.timer,
                          size: 24,
                          color: Styles.nearlyWhite,
                        ),
                        backgroundColor: widget.primaryColor,
                      ),
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Text(
                                DateFormat('HH:mm - dd/MM/yyyy').format(
                                  state.policies[i].timeStart,
                                ),
                                style: TextStyle(
                                  color: Styles.nearlyBlack,
                                  fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          Place.districts[state.policies[i].placement],
                          style: TextStyle(
                            color: Styles.nearlyBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyForm extends StatefulWidget {
  final String deviceId;
  final Color primaryColor;
  final Function() fabHandler;

  const PrivacyForm(
      {Key key, this.primaryColor, this.fabHandler, this.deviceId})
      : super(key: key);

  @override
  _PrivacyFormState createState() => _PrivacyFormState();
}

class _PrivacyFormState extends State<PrivacyForm> {
  DateTime _timeStart;
  DateTime _timeEnd;
  int _placement;

  @override
  void initState() {
    super.initState();
    _timeStart = null;
    _timeEnd = null;
    _placement = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: _buildFormBar(context),
      ),
      body: Column(
        children: <Widget>[
          _timeStartPicker(context),
          _timeEndPicker(context),
          _placementPicker(context),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: widget.fabHandler,
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
    ;
  }

  Widget _buildFormBar(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "New ${widget.deviceId}'s Privacy",
              style: TextStyle(
                  color: Styles.nearlyBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.transparent,
          splashColor: widget.primaryColor.withOpacity(0.15),
          highlightElevation: 0,
          elevation: 0,
          onPressed: () {
            final privacy = Privacy(
              null,
              deviceId: widget.deviceId,
              timeStart: _timeStart.toUtc(),
              timeEnd: _timeEnd.toUtc(),
              placement: Place.districts.keys.toList()[_placement],
            );
            final payload = {
              'deviceId': widget.deviceId,
              'privacy': privacy.toJson(),
            };

            widget.fabHandler();
            BlocProvider.of<PrivacyBloc>(context)
                .add(PostPrivacy(null, payload));
          },
          child: Icon(
            Icons.check,
            size: 24,
            color: widget.primaryColor,
          ),
          foregroundColor: widget.primaryColor,
        ),
      ],
    );
  }

  Widget _timeStartPicker(BuildContext context) {
    return FadeIn(
      delay: 0,
      translateX: false,
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                "Time Start",
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  _timeStart == null
                      ? ''
                      : DateFormat('HH:mm MMM dd, yyyy').format(_timeStart),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FloatingActionButton(
                onPressed: () {
                  final oneShot = DateTime.now();
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.5,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Time Start',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: widget.primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.dateAndTime,
                                initialDateTime: oneShot,
                                minimumDate: oneShot,
                                maximumDate: oneShot.add(Duration(days: 30)),
                                onDateTimeChanged: (value) {
                                  setState(() => _timeStart = value);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                elevation: 0,
                highlightElevation: 0,
                mini: true,
                backgroundColor: Colors.transparent,
                shape: CircleBorder(
                  side: BorderSide(
                    color: widget.primaryColor,
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  color: widget.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeEndPicker(BuildContext context) {
    return FadeIn(
      delay: 0.4,
      translateX: false,
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                "Time End",
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  _timeEnd == null
                      ? ''
                      : DateFormat('HH:mm MMM dd, yyyy').format(_timeEnd),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: FloatingActionButton(
                  onPressed: () {
                    final oneShot = DateTime.now();
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.5,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Time End',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: widget.primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.dateAndTime,
                                  initialDateTime: oneShot,
                                  minimumDate: oneShot,
                                  maximumDate: oneShot.add(Duration(days: 30)),
                                  onDateTimeChanged: (value) {
                                    setState(() => _timeEnd = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  elevation: 0,
                  highlightElevation: 0,
                  mini: true,
                  backgroundColor: Colors.transparent,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: widget.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: widget.primaryColor,
                    size: 24,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _placementPicker(BuildContext context) {
    return FadeIn(
      delay: 0.8,
      translateX: false,
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                "Place",
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  _placement == -1
                      ? ''
                      : Place.districts.values.toList()[_placement],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FloatingActionButton(
                elevation: 0,
                highlightElevation: 0,
                mini: true,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.5,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Placement',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: widget.primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                children: Place.districts.values
                                    .map(
                                      (item) => Center(
                                        child: Text('${item.split(',')[0]}'),
                                      ),
                                    )
                                    .toList(),
                                onSelectedItemChanged: (i) {
                                  setState(() => _placement = i);
                                },
                                itemExtent: 40.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                shape: CircleBorder(
                  side: BorderSide(
                    color: widget.primaryColor,
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  color: widget.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
