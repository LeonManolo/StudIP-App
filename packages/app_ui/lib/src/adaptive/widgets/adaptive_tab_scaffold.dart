import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AdaptiveTabScaffold extends StatefulWidget {
  const AdaptiveTabScaffold({
    super.key,
    required this.tabs,
    required this.items,
    this.iOSTabBarIconSize = 27,
  });

  final List<Widget> tabs;
  final List<BottomNavigationBarItem> items;
  final double iOSTabBarIconSize;

  @override
  State<AdaptiveTabScaffold> createState() => _AdaptiveTabScaffoldState();
}

class _AdaptiveTabScaffoldState extends State<AdaptiveTabScaffold> {
  int _selectedTab = 0;

  final _tabController = PlatformTabController();

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: _tabController,
      material: (context, index) => MaterialTabScaffoldData(
        bodyBuilder: (_, __) => IndexedStack(
          index: _selectedTab,
          children: widget.tabs,
        ),
      ),
      cupertino: (_, __) => CupertinoTabScaffoldData(
        bodyBuilder: (context, index) => widget.tabs[index],
      ),
      cupertinoTabs: (context, index) => CupertinoTabBarData(
        iconSize: widget.iOSTabBarIconSize,
      ),
      materialTabs: (_, __) => MaterialNavBarData(
        type: BottomNavigationBarType.fixed,
      ),
      items: widget.items,
      itemChanged: (value) {
        setState(() {
          _selectedTab = value;
        });
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
