import 'package:flutter/material.dart';
import 'package:studipadawan/courses/view/courses_page.dart';
import 'package:studipadawan/home/view/home_page.dart';
import 'package:studipadawan/login/view/authenticated_page.dart';

import '../../login/view/view.dart';
import '../bloc/app_bloc.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    AppStatus state,
    List<Page<dynamic>> pages,
    ) {
  switch (state) {
    case AppStatus.authenticated:
      return [AuthenticatedPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}