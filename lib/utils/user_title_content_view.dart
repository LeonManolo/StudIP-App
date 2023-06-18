

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.sm),
        HtmlWidget(
          content,
          onTapUrl: (url) async {
            if (!await canLaunchUrlString(url)) return false;
            return launchUrlString(url);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(userFormattedName.split('').firstOrNull ?? ''),
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

