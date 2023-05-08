import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id);
  final String id;

  static const empty = User('');

  @override
  List<Object?> get props => [id];

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;
}
