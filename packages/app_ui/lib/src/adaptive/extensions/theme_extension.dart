
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

   Color? get adaptiveTextColor {
     if (Platform.isIOS) {
       return CupertinoTheme.of(this).textTheme.textStyle.color;
     }
     return Theme.of(this).textTheme.bodyMedium?.color;
   }

   Color? get adaptiveHintColor {
     if (Platform.isIOS) {
       return CupertinoColors.separator;
     }
     return Theme.of(this).hintColor;
   }

   Color? get adaptiveSecondaryBackgroundColor {
     if (Platform.isIOS) {
       return CupertinoColors.secondarySystemBackground;
     }
     return Theme.of(this).colorScheme.surfaceVariant;
   }
}
