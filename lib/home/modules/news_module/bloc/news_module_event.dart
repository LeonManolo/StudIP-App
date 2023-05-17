import 'package:equatable/equatable.dart';

abstract class NewsModuleEvent extends Equatable {
  const NewsModuleEvent();
}

class CoursesRequested extends NewsModuleEvent {
  @override
  List<Object?> get props => [];
}
