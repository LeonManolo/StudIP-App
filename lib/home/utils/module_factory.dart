import 'package:flutter/material.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/models/preview_model.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_preview_model.dart';
import 'package:studipadawan/home/modules/calendar_module/widgets/calendar_preview_tile.dart';
import 'package:studipadawan/home/modules/files_module/model/file_preview_model.dart';
import 'package:studipadawan/home/modules/files_module/widgets/files_preview_tile.dart';
import 'package:studipadawan/home/modules/message_module/model/message_preview_model.dart';
import 'package:studipadawan/home/modules/message_module/widgets/message_preview_tile.dart';
import 'package:studipadawan/home/modules/news_module/model/news_preview_model.dart';
import 'package:studipadawan/home/modules/news_module/widgets/news_preview_tile.dart';

Widget moduleListTileFactory({
  required ModuleType type,
  required PreviewModel previewModel,
  VoidCallback? onRefresh,
}) {
  switch (type) {
    case ModuleType.files:
      return FilePreviewTile(
        key: UniqueKey(),
        filePreviewModel: previewModel as FilePreviewModel,
      );

    case ModuleType.messages:
      return MessagePreviewTile(
        key: UniqueKey(),
        messagePreview: previewModel as MessagePreviewModel,
        onRefresh: onRefresh,
      );

    case ModuleType.news:
      return NewsPreviewTile(
        key: UniqueKey(),
        newsPreviewModel: previewModel as NewsPreviewModel,
      );

    case ModuleType.calendar:
      return CalendarPreviewTile(
        key: UniqueKey(),
        calendarEntry: previewModel as CalendarPreviewModel,
      );
  }
}
