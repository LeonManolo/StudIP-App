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
  });

  final String replacementLetter;
  final String? profileImageUrl;
  final Color? backgroundColor;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

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
      backgroundColor:
          backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxs),
        child: switch (_getImageUrl()) {
          null => _FirstLetterText(letter: replacementLetter),
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
  const _FirstLetterText({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Text(
      letter.split('').firstOrNull ?? '',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
