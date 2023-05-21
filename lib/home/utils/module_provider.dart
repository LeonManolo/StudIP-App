import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/calendar_module/view/calendar_module.dart';
import 'package:studipadawan/home/modules/files_module/view/files_module.dart';
import 'package:studipadawan/home/modules/message_module/view/message_module.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/news_module/view/news_module.dart';

Module getModule(ModuleType type) {
  switch (type) {
    case ModuleType.files:
      return const FilesModule();
    case ModuleType.messages:
      return const MessageModule();
    case ModuleType.news:
      return const NewsModule();
    case ModuleType.calendar:
      return const CalendarModule();
  }
}
