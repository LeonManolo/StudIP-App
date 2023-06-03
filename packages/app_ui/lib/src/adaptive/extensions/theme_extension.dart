
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ThemeAdaptivePrimaryColor on BuildContext {
   Color get adaptivePrimaryColor {
     if (Platform.isIOS) {
       return CupertinoTheme.of(this).primaryColor;
     }
    return Theme.of(this).primaryColor;
   }
}
