import 'package:flutter/cupertino.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';

abstract class Module extends Widget {
  const Module({super.key});
  Map<String, dynamic> toJson();
  ModuleType getType();
}
