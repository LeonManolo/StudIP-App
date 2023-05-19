import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';

const double radius = 15;

class MoudleCard extends StatelessWidget {
  const MoudleCard({
    super.key,
    required this.child,
    required this.type,
  });
  final Widget child;
  final ModuleType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 2, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              ),
            ),
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    type.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )),
        Container(
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 0.2,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ],
    );
  }
}
