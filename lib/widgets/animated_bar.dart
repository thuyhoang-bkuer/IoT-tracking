import 'dart:io';

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
        padding: EdgeInsets.only(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
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
      return Expanded(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              _selectedIndex = i;
              widget.onItemTap(_selectedIndex);
            });
          },
          child: AnimatedContainer(
            duration: widget.animationDuration,
            padding:
                const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: SizedBox(
              // width: (MediaQuery.of(context).size.width - 32 * 3) * 0.33,
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    item.iconData,
                    color: isSelected ? item.color : Styles.nearlyBlack,
                    size: item.iconSize,
                  ),
                  SizedBox(width: 10),
                  AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    vsync: this,
                    child: Text(
                      item.text,
                      style: TextStyle(
                        color: isSelected ? item.color : Styles.nearlyBlack,
                        fontWeight: item.fontWeight,
                        fontSize: item.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
