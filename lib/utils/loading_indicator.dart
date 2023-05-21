import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.size = 24, this.color, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: size,
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}
