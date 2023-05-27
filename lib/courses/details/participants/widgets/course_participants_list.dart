import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/participants/widgets/course_participant_list_tile.dart';

class CourseParticipantsList extends StatefulWidget {
  const CourseParticipantsList({
    super.key,
    required this.participants,
    required this.onBottomReached,
    required this.onRefresh,
  });

  final List<Participant> participants;
  final VoidCallback onBottomReached;
  final VoidCallback onRefresh;

  @override
  State<CourseParticipantsList> createState() => _CourseParticipantsListState();
}

class _CourseParticipantsListState extends State<CourseParticipantsList> {

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView.separated(
        itemCount: widget.participants.length,
        itemBuilder: (context, index) {
          final participant = widget.participants[index];
          return CourseParticipantListTile(participant: participant);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            //height: 1,
            indent: AppSpacing.xxlg + AppSpacing.sm,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) widget.onBottomReached();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
