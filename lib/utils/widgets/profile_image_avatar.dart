import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ProfileImageAvatar extends StatelessWidget {
  const ProfileImageAvatar({
    super.key,
    required this.replacementLetter,
    this.profileImageUrl,
    this.backgroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.fontSize,
  });

  final String replacementLetter;
  final String? profileImageUrl;
  final Color? backgroundColor;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
      backgroundImage: switch (_getImageUrl()) {
        final String url => NetworkImage(url),
        _ => null,
      },
      backgroundColor: backgroundColor ??
          Theme.of(context).primaryColor.withOpacity(
                Theme.of(context).brightness == Brightness.light ? 0.1 : 0.3,
              ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxs),
        child: switch (_getImageUrl()) {
          null => _FirstLetterText(
              letter: replacementLetter,
              fontSize: fontSize,
            ),
          _ => null,
        },
      ),
    );
  }

  bool _isDefaultImageUrl() {
    return profileImageUrl?.contains('pictures/user/nobody') ?? false;
  }

  String? _getImageUrl() {
    if (_isDefaultImageUrl()) {
      return null;
    }
    return profileImageUrl;
  }
}

class _FirstLetterText extends StatelessWidget {
  const _FirstLetterText({
    required this.letter,
    this.fontSize,
  });

  final String letter;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      letter.split('').firstOrNull ?? '',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: fontSize,
      ),
    );
  }
}
