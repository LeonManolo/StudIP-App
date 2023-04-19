import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsSection extends ExpansionTile {
  NewsSection(
      {Key? key,
      required NewsExpansionModel newsExpansionModel,
      required Function(bool) onExpansionChanged})
      : super(
          key: key,
          title: const Text("Ankündigungen"),
          children: [
            for (int index = 0; index < newsExpansionModel.news.length; index++)
              Column(
                children: [
                  ListTile(
                    title: Text(newsExpansionModel.news.elementAt(index).title),
                    subtitle: Html(
                        data: newsExpansionModel.news.elementAt(index).content),
                  ),
                  index < (newsExpansionModel.news.length - 1)
                      ? const Divider()
                      : const SizedBox.shrink()
                ],
              )
          ],
          initiallyExpanded: newsExpansionModel.isExpanded,
          onExpansionChanged: (isExpanded) => onExpansionChanged(isExpanded),
        );
}
