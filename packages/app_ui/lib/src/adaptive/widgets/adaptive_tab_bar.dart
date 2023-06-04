import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTabBar extends StatefulWidget {
  const AdaptiveTabBar({super.key, required this.tabs, this.onValueChanged, this.selectedTab});

  final List<({String title, Widget widget})> tabs;
  final ValueChanged<int>? onValueChanged;
  final int? selectedTab;

  @override
  State<AdaptiveTabBar> createState() => _AdaptiveTabBarState();
}

class _AdaptiveTabBarState extends State<AdaptiveTabBar> {
  int _selectedItem = 0;

  @override
  void initState() {
    if (widget.selectedTab != null) {
      _selectedItem = widget.selectedTab!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSlidingSegmentedControl<int>(
        groupValue: _selectedItem,
        onValueChanged: (int? value) {
          if (value != null) {
            setState(() {
              _selectedItem = value;
              if (widget.onValueChanged != null) {
                widget.onValueChanged!(value);
              }
            });
          }
        },
        children: _cupertinoTabs(),
      );
    } else {
      return TabBar(tabs: widget.tabs.map((tab) => tab.widget).toList());
    }
  }

  Map<int, Widget> _cupertinoTabs() {
    final cupertinoTabs = <int, Widget>{};
    for (var i = 0; i < widget.tabs.length; i++) {
      cupertinoTabs.addAll({
        i: Text(widget.tabs[i].title),
      });
    }
    return cupertinoTabs;
  }
}
