import 'package:studip_api_client/studip_api_client.dart';

class CourseEventListResponse implements ItemListResponse<CourseEventResponse> {
  final List<CourseEventResponse> events;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int total;

  CourseEventListResponse({
    required this.events,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory CourseEventListResponse.fromJson(Map<String, dynamic> json) {
    final page = json["meta"]["page"];
    List<dynamic> events = json["data"];

    return CourseEventListResponse(
      events: events
          .map((rawEvents) => CourseEventResponse.fromJson(rawEvents))
          .toList(),
      offset: page["offset"],
      limit: page["limit"],
      total: page["total"],
    );
  }

  @override
  List<CourseEventResponse> get items => events;
}

class CourseEventResponse {
  final String id;
  final String title;
  final String description;
  final String start;
  final String end;
  final List<String> categories;
  final String? location;

  CourseEventResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.categories,
    this.location,
  });

  factory CourseEventResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["attributes"];
    List<dynamic> rawCategories = attributes["categories"];
    return CourseEventResponse(
      id: json["id"],
      title: attributes["title"],
      description: attributes["description"],
      start: attributes["start"],
      end: attributes["end"],
      categories: rawCategories.map((rawCategory) => "$rawCategory").toList(),
    );
  }
}
