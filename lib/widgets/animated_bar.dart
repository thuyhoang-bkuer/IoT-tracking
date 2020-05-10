import 'package:flutter/material.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/styles/index.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<AnimatedItem> items;
  final Function onItemTap;
  final Duration animationDuration;

  const AnimatedBottomBar({
    Key key,
    this.items,
    this.onItemTap,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 32,
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildItems(),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return List<Widget>.generate(widget.items.length, (int i) {
      var item = widget.items[i];
      var isSelected = _selectedIndex == i;
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            _selectedIndex = i;
            widget.onItemTap(_selectedIndex);
          });
        },
        child: AnimatedContainer(
          duration: widget.animationDuration,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color:
                isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                item.iconData,
                color: isSelected ? item.color : Styles.nearlyBlack,
                size: item.iconSize,
              ),
              SizedBox(width: isSelected ? 10 : 0),
              AnimatedSize(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                vsync: this,
                child: Text(
                  isSelected ? item.text : "",
                  style: TextStyle(
                    color: item.color,
                    fontWeight: item.fontWeight,
                    fontSize: item.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

