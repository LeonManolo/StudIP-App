import 'package:equatable/equatable.dart';

abstract class NewsModuleEvent extends Equatable {
  const NewsModuleEvent();
}
class NewsActivitiesRequested extends NewsModuleEvent {
  const NewsActivitiesRequested();

  @override
  List<Object?> get props => [];
}