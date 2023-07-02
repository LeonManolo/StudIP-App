import 'package:flutter/material.dart';

ButtonStyle segmentedButtonStyle({required BuildContext context}) {
  // https://stackoverflow.com/a/75286190
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      return states.contains(MaterialState.selected)
          ? Theme.of(context).primaryColor
          : Colors.black12;
    }),
  );
}
