class Asset {
  String id;
  String name;
  String? locationId;
  String? parentId;
  String? sensorType;
  String? status;

  Asset.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        locationId = map['locationId'],
        parentId = map['parentId'],
        sensorType = map['sensorType'],
        status = map['status'];

  static List<Asset> fromMaps(List<dynamic> maps) {
    return maps.map((asset) => Asset.fromMap(asset)).toList();
  }
}

  
  
  // {
  //   "name": "Asset 18",
  //   "id": "60fc7ca686cd05001d22b4d8",
  //   "locationId": "60fc7c9e86cd05001d22b4d5",
  //   "parentId": null,
  //   "sensorType": null,
  //   "status": null
  // },