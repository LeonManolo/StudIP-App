import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

IconData fileTypeToIcon({required String fileName}) {
  final String fileType = fileName.characters
      .takeLastWhile((char) => char != '.')
      .toString()
      .toLowerCase();

  // Common MIME Types: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  if (['mp4', 'mov', 'mpeg', 'ogv', 'webm'].contains(fileType)) {
    // Videos
    return EvaIcons.filmOutline;
  } else if (['gif', 'ico', 'jpeg', 'jpg', 'svg', 'tif', 'tiff', 'webp', 'png']
      .contains(fileType)) {
    // Images
    return EvaIcons.imageOutline;
  } else if (['mp3', 'm4a', 'wav', 'weba', 'opus', 'oga', 'mid', 'midi']
      .contains(fileType)) {
    // audio files
    return Icons.audio_file_outlined;
  } else if (['pdf', 'docx', 'odt', 'txt', 'rtf'].contains(fileType)) {
    // text documents
    return EvaIcons.fileTextOutline;
  } else {
    return EvaIcons.fileOutline;
  }
}
