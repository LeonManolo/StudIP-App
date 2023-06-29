import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.messageIcon,
    required this.onTapFunction,
    required this.title,
    required this.subTitle,
    this.onLongPressFunction,
  });
  final Widget messageIcon;
  final String title;
  final String subTitle;
  final void Function() onTapFunction;
  final void Function()? onLongPressFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => {onTapFunction()},
      onLongPress: () => {
        if (onLongPressFunction != null) {onLongPressFunction!()}
      },
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[messageIcon],
      ),
      title: Text(title),
      subtitle: Text(subTitle),
    );
  }
}
