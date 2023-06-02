import 'dart:io';

import 'package:app_ui/src/adaptive/widgets/adaptive_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.adaptiveAppBar,
    //this.isTabbedScaffold = false,
  });

  //final bool isTabbedScaffold;
  final Widget body;
  final AdaptiveAppBar? adaptiveAppBar;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        //navigationBar: adaptiveAppBar,
          child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: body,
    );
  }
}
