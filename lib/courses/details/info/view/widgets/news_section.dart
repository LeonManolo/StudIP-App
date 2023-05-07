import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:studipadawan/courses/details/info/models/models.dart';

class NewsSection extends ExpansionTile {
  NewsSection({
    super.key,
    required NewsExpansionModel newsExpansionModel,
    required void Function(bool) onExpansionChanged,
  }) : super(
          title: const Text('Ankündigungen'),
          children: [
            for (int index = 0; index < newsExpansionModel.news.length; index++)
              Column(
                children: [
                  ListTile(
                    title: Text(newsExpansionModel.news.elementAt(index).title),
                    subtitle: Html(
                      data: newsExpansionModel.news.elementAt(index).content,
                    ),
                  ),
                  if (index < (newsExpansionModel.news.length - 1))
                    const Divider()
                  else
                    const SizedBox.shrink()
                ],
              )
          ],
          initiallyExpanded: newsExpansionModel.isExpanded,
          onExpansionChanged: (isExpanded) => onExpansionChanged(isExpanded),
        );
}
