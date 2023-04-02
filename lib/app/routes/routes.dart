import 'package:flutter/material.dart';
import 'package:studipadawan/courses/view/courses_page.dart';
import 'package:studipadawan/home/view/home_page.dart';

import '../../login/view/view.dart';
import '../bloc/app_bloc.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    AppStatus state,
    List<Page<dynamic>> pages,
    ) {
  print("state: $state");
  switch (state) {
    case AppStatus.authenticated:
      return [CoursesPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}