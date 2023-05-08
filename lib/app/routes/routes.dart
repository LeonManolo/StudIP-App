import 'package:flutter/material.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/login/view/authenticated_page.dart';
import 'package:studipadawan/login/view/view.dart';

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
