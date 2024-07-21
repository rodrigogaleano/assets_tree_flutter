class Location {
  String id;
  String name;
  String? parentId;

  Location.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        parentId = map['parentId'];

  static List<Location> fromMaps(List<dynamic> maps) {
    return maps.map((location) => Location.fromMap(location)).toList();
  }
}
