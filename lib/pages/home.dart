import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/data/device_repository.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/pages/screens/_.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/widgets/animated_bar.dart';
import 'package:tracking_app/widgets/title_bar.dart';

class HomePage extends StatefulWidget {
  List<AnimatedItem> tabItems = [
    AnimatedItem(
      text: "Devices",
      iconData: Icons.device_hub,
      color: Styles.greeny,
      screen: DeviceScreen(),
      fontSize: 18,
    ),
    AnimatedItem(
      text: "Track",
      iconData: Icons.gps_fixed,
      color: Styles.yellowy,
      screen: TrackingScreen(),
      fontSize: 18,
    ),
    AnimatedItem(
      text: "Setting",
      iconData: Icons.settings,
      color: Styles.greeny,
      screen: SettingScreen(),
      fontSize: 18,
    ),
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex;
  List<Device> devices = [Device(id: 1234, name: 'World_One')];

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeviceBloc(new LocalDeviceRepository()),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(new LocalDeviceRepository()),
        )
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: TitleBar(primaryColor: widget.tabItems[_pageIndex].color),
        ),
        body: Container(
          // create: (context) => HomeBloc(devices),
          child: widget.tabItems[_pageIndex].screen,
        ),
        bottomNavigationBar: AnimatedBottomBar(
          items: widget.tabItems,
          onItemTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
