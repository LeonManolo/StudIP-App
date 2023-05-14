
/// meta : {"semester":"/jsonapi.php/v1/semesters/322f640f3f4643ebe514df65f1163eb1"}
/// links : {"self":"/jsonapi.php/v1/users/4924eb9d441c495ebeaf237567f17aa2/schedule?filter%5Btimestamp%5D=1680300000"}
/// data : [{"type":"schedule-entries","id":"1","attributes":{"title":"Meeting","description":"Meeting am Mittwoch","start":"12:15","end":"13:45","weekday":3,"color":"12"},"relationships":{"owner":{"links":{"related":"/jsonapi.php/v1/users/4924eb9d441c495ebeaf237567f17aa2"},"data":{"type":"users","id":"4924eb9d441c495ebeaf237567f17aa2"}}},"links":{"self":"/jsonapi.php/v1/schedule-entries/1"}},{"type":"seminar-cycle-dates","id":"14d7461f94f9a86dfb21537d0ff1dada","attributes":{"title":"Theoretische Informatik","description":null,"start":"10:00","end":"11:30","weekday":3,"recurrence":{"FREQ":"WEEKLY","INTERVAL":1,"DTSTART":"2023-04-12T10:00:00+02:00","UNTIL":"2023-07-12T10:00:00+02:00"},"locations":["HÃ¶rsaal 1"]},"relationships":{"owner":{"links":{"related":"/jsonapi.php/v1/courses/076ef4c2a9b3e0f99d73c5333d54d22a"},"data":{"type":"courses","id":"076ef4c2a9b3e0f99d73c5333d54d22a"}}},"links":{"self":"/jsonapi.php/v1/seminar-cycle-dates/14d7461f94f9a86dfb21537d0ff1dada"}},{"type":"seminar-cycle-dates","id":"d5ff07b569cc369b0e0ff8dc2c95f1bf","attributes":{"title":"Software-Architektur","description":null,"start":"10:00","end":"11:30","weekday":4,"recurrence":{"FREQ":"WEEKLY","INTERVAL":1,"DTSTART":"2023-04-13T10:00:00+02:00","UNTIL":"2023-07-13T10:00:00+02:00","EXDATES":["2023-05-18T10:00:00+02:00"]},"locations":["Seminarraum 1"]},"relationships":{"owner":{"links":{"related":"/jsonapi.php/v1/courses/7532b23f5aebe38cf14c7a50a412c47b"},"data":{"type":"courses","id":"7532b23f5aebe38cf14c7a50a412c47b"}}},"links":{"self":"/jsonapi.php/v1/seminar-cycle-dates/d5ff07b569cc369b0e0ff8dc2c95f1bf"}}]

class ScheduleResponse {
  ScheduleResponse({required this.meta, required this.data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    final meta = Meta.fromJson(json['meta']);
    final List<Data> data = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    return ScheduleResponse(meta: meta, data: data);
  }

  Meta meta;
  List<Data> data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meta'] = meta.toJson();
    map['data'] = data.map((v) => v.toJson()).toList();
    return map;
  }
}

/// type : "schedule-entries"
/// id : "1"
/// attributes : {"title":"Meeting","description":"Meeting am Mittwoch","start":"12:15","end":"13:45","weekday":3,"color":"12"}
/// relationships : {"owner":{"links":{"related":"/jsonapi.php/v1/users/4924eb9d441c495ebeaf237567f17aa2"},"data":{"type":"users","id":"4924eb9d441c495ebeaf237567f17aa2"}}}
/// links : {"self":"/jsonapi.php/v1/schedule-entries/1"}

class Data {
  Data({
    required this.type,
    required this.id,
    this.attributes,
    this.relationships,
    this.links,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final String type = json['type'];
    final String id = json['id'];
    final attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    final relationships = json['relationships'] != null
        ? Relationships.fromJson(json['relationships'])
        : null;
    final links = json['links'] != null ? Links.fromJson(json['links']) : null;
    return Data(
        type: type,
        id: id,
        attributes: attributes,
        relationships: relationships,
        links: links);
  }

  final String type;
  String id;
  Attributes? attributes;
  Relationships? relationships;
  Links? links;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['id'] = id;
    if (attributes != null) {
      map['attributes'] = attributes?.toJson();
    }
    if (relationships != null) {
      map['relationships'] = relationships?.toJson();
    }
    if (links != null) {
      map['links'] = links?.toJson();
    }
    return map;
  }
}

/// owner : {"links":{"related":"/jsonapi.php/v1/users/4924eb9d441c495ebeaf237567f17aa2"},"data":{"type":"users","id":"4924eb9d441c495ebeaf237567f17aa2"}}

class Relationships {
  Relationships({
    this.owner,
  });

  Relationships.fromJson(Map<String, dynamic> json) {
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }

  Owner? owner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (owner != null) {
      map['owner'] = owner?.toJson();
    }
    return map;
  }
}

/// links : {"related":"/jsonapi.php/v1/users/4924eb9d441c495ebeaf237567f17aa2"}
/// data : {"type":"users","id":"4924eb9d441c495ebeaf237567f17aa2"}

class Owner {
  Owner({
    this.links,
    this.data,
  });

  Owner.fromJson(Map<String, dynamic> json) {
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    data =
        json['data'] != null ? RelationshipData.fromJson(json['data']) : null;
  }

  Links? links;
  RelationshipData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (links != null) {
      map['links'] = links?.toJson();
    }
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

/// type : "users"
/// id : "4924eb9d441c495ebeaf237567f17aa2"

class RelationshipData {
  RelationshipData({
    this.type,
    this.id,
  });

  RelationshipData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  String? type;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['id'] = id;
    return map;
  }
}

/// related : "/jsonapi.php/v1/users/4924eb9d441c495ebeaf237567f17aa2"

class Links {
  Links({
    this.related,
  });

  Links.fromJson(Map<String, dynamic> json) {
    related = json['related'];
  }

  String? related;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['related'] = related;
    return map;
  }
}

/// title : "Meeting"
/// description : "Meeting am Mittwoch"
/// start : "12:15"
/// end : "13:45"
/// weekday : 3
/// color : "12"

class Attributes {
  Attributes({
    this.title,
    this.description,
    this.start,
    this.end,
    this.weekday,
    this.color,
    required this.locations,
  });

  Attributes.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    start = json['start'];
    end = json['end'];
    weekday = json['weekday'];
    color = json['color'];
    locations = json['locations'] != null ? json['locations'].cast<String>() : [];
  }

  late final String? title;
  late final String? description;
  late final String? start;
  late final String? end;
  late final int? weekday;
  late final String? color;
  late final List<String> locations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['start'] = start;
    map['end'] = end;
    map['weekday'] = weekday;
    map['color'] = color;
    return map;
  }
}

/// semester : "/jsonapi.php/v1/semesters/322f640f3f4643ebe514df65f1163eb1"

class Meta {
  Meta({
    this.semester,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    semester = json['semester'];
  }

  String? semester;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['semester'] = semester;
    return map;
  }
}
