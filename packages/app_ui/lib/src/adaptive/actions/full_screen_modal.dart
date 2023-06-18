import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> showAdaptiveFullScreenModal({
  required BuildContext context,
  String title = '',
  List<Widget> trailing = const [],
  Widget? leading,
  VoidCallback? onClose,
  Widget body = const SizedBox.shrink(),
}) async {
  if (Platform.isIOS) {
    await showCupertinoModalBottomSheet<void>(
      expand: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          onClose?.call();
          return true;
        },
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
          navigationBar: CupertinoNavigationBar(
            backgroundColor:
                CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.85),
            automaticallyImplyLeading: true,
            border: Border.all(width: 0, color: Colors.transparent),
            middle: Text(title),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Abbrechen'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: trailing,
            ),
          ),
          child: body,
        ),
      ),
    );
  } else {
    await Navigator.push(
      context,
      MaterialPageRoute<Scaffold>(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: leading,
            actions: trailing,
          ),
          body: body,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
