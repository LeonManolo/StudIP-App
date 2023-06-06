
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

extension AdaptivePush on NavigatorState {
  Future<T?> pushAdaptive<T extends Widget>(BuildContext context, T page) {
    return Navigator.push(
      context,
      platformPageRoute<T>(
        context: context,
        builder: (context) => page,
      ),
    );
  }
}