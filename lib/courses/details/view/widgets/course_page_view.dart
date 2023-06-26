import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/view/widgets/course_page_view_header.dart';
import 'package:studipadawan/courses/details/view/widgets/course_page_view_tab_item.dart';

class CoursePageView extends StatefulWidget {
  const CoursePageView({super.key, required this.content});

  final List<CoursePageViewData> content;

  @override
  State<CoursePageView> createState() => _CoursePageViewState();
}

class _CoursePageViewState extends State<CoursePageView> {
  final tabWidth = 105.0;
  final animationDuration = const Duration(milliseconds: 200);
  final animationCurve = Curves.easeInOut;

  final _pageController = PageController();
  final _scrollController = ScrollController();
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: CoursePageViewHeader(
            controller: _scrollController,
            onTabChanged: (tabIndex) {
              _scrollToTabIndex(tabIndex);
              _pageController.jumpToPage(
                tabIndex,
              );
            },
            tabItems: [
              ...widget.content.mapIndexed(
                (index, tabItem) => CoursePageViewTabItem(
                  icon: tabItem.tab.icon,
                  active: _pageIndex == index,
                  title: tabItem.tab.title,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
            ),
            child: PageView(
              onPageChanged: _onPageChange,
              controller: _pageController,
              children: [
                ...widget.content.map((pageViewData) => pageViewData.content)
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Callback for PageView's onPageChanged event.
  /// Changes the active tab based on the provided [index]
  /// and scrolls the header to the correct position.
  void _onPageChange(int index) {
    _scrollToTabIndex(index);
    setState(() {
      _pageIndex = index;
    });
  }

  /// Animates the CoursePageViewHeader's ScrollController to the provided [index].
  void _scrollToTabIndex(int index) {
    _scrollController.animateTo(
      _setScrollOffset(index),
      duration: animationDuration,
      curve: animationCurve,
    );
  }

  /// Sets the ScrollController's offset based on the given [index].
  /// Returns the scroll offset that corresponds to the [index].
  /// If the offset is more than the maximum scroll extent,
  /// then the maximum scroll extent is returned.
  double _setScrollOffset(int index) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = index * tabWidth;
    return offset > maxScroll ? maxScroll : offset;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class CoursePageViewData {
  const CoursePageViewData({
    required this.content,
    required this.tab,
  });

  final Widget content;
  final CoursePageViewTabData tab;
}

class CoursePageViewTabData {
  const CoursePageViewTabData({
    this.color,
    required this.icon,
    required this.title,
  });

  final Color? color;
  final IconData icon;
  final String title;
}
