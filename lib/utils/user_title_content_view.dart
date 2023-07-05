import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/utils/widgets/html_view.dart';
import 'package:studipadawan/utils/widgets/profile_image_avatar.dart';

enum UserTitleContentAction {
  edited('bearbeitet'),
  created('erstellt');

  const UserTitleContentAction(this.description);

  final String description;
}

class UserTitleContentView extends StatelessWidget {
  const UserTitleContentView({
    super.key,
    required this.userAvatarUrl,
    required this.userFormattedName,
    required this.userAction,
    required this.formattedPublicationDate,
    required this.title,
    required this.content,
  });

  final String userAvatarUrl;
  final String userFormattedName;
  final UserTitleContentAction userAction;
  final String formattedPublicationDate;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        HtmlView(html: content),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ProfileImageAvatar(
            replacementLetter: userFormattedName,
            profileImageUrl: userAvatarUrl,
          ),
          title: Text.rich(
            TextSpan(
              text: 'Von ',
              children: [
                TextSpan(
                  text: userFormattedName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: ' ${userAction.description}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          subtitle: Text(
            formattedPublicationDate,
          ),
        ),
      ],
    );
  }
}
