import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> showAdaptiveFullScreenModal({
  required BuildContext context,
  required Widget content,
}) async {
  if (Platform.isIOS) {
    await showCupertinoModalBottomSheet<void>(
      expand: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => content,
    );
  } else {
    await Navigator.push(
      context,
      MaterialPageRoute<Scaffold>(
        builder: (context) => content,
        fullscreenDialog: true,
      ),
    );
  }
}

/*
CupertinoPageScaffold(
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
      )
 */
