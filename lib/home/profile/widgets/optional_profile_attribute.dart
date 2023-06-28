import 'package:flutter/material.dart';

class OptionalProfileAttribute extends StatelessWidget {
  const OptionalProfileAttribute({
    super.key,
    required this.iconData,
    this.title,
    this.displayDivider = true,
  });

  final IconData iconData;
  final String? title;
  final bool displayDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          ListTile(
            leading: Icon(iconData),
            title: Text(title!),
          ),
        if (displayDivider && title != null) const Divider(),
      ],
    );
  }
}
