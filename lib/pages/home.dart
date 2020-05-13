import 'package:flutter/material.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/pages/screens/_.dart';
import 'package:tracking_app/widgets/animated_bar.dart';

class HomePage extends StatefulWidget {
  List<AnimatedItem> tabItems = [
    AnimatedItem(
      text: "History",
      iconData: Icons.history,
      color: Color(0xFFF4B400),
      screen: HistoryScreen(),
    ),
    AnimatedItem(
      text: "Track",
      iconData: Icons.gps_fixed,
      color: Color(0xFF0F9D58),
      screen: TrackingScreen(),
    ),
    AnimatedItem(
      text: "Privacy",
      iconData: Icons.book,
      color: Color(0xFFDB4437),
      screen: PrivacyScreen(),
    ),
    AnimatedItem(
      text: "Setting",
      iconData: Icons.settings,
      color: Color(0xFF4285F4),
      screen: SettingScreen(),
    ),
  ];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex;
  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          _buildOffstageNavigator(3)
        ],
      ),
      bottomNavigationBar: AnimatedBottomBar(
        items: widget.tabItems,
        onItemTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HistoryScreen(),
          TrackingScreen(),
          PrivacyScreen(),
          SettingScreen()
        ].elementAt(index);
      },
    };
  }
  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _pageIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}