import 'package:flutter/material.dart';

const double radius = 15;

class MoudleCard extends StatelessWidget {
  const MoudleCard({super.key, required this.module, required this.headline});
  final Widget module;
  final String headline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Logik zum entfernen des Moduls
                  },
                ),
              ],
            ),
          ),
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
            child: module,
          ),
        ],
      ),
    );
  }
}
