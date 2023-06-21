import 'package:app_ui/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: platformThemeData(
                    context,
                    material: (theme) => null,
                    cupertino: (cupertino) =>
                        cupertino.textTheme.textStyle.color,
                  ),
                ),
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: platformThemeData(
                context,
                material: (materialTheme) => materialTheme.hintColor,
                cupertino: (cupertino) => CupertinoColors.systemGrey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
