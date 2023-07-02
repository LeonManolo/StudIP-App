import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

Future<void> showCustomModalBottomSheet({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    builder: (_) {
      return _ModalBottomSheet(title: title, child: child);
    },
  );
}

class _ModalBottomSheet extends StatelessWidget {
  const _ModalBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).hintColor.withOpacity(0.1),
                    foregroundColor:
                        Theme.of(context).textTheme.labelMedium?.color,
                    child: const Icon(EvaIcons.close),
                  ),
                )
              ],
            ),
          ),
          child,
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
