import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      onTapUrl: (url) async {
        if (!await canLaunchUrlString(url)) {
          return false;
        }
        return launchUrlString(url);
      },
    );
  }
}
