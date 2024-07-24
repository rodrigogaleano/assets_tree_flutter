class Asset {
  String id;
  String name;
  String? status;
  String? parentId;
  String? locationId;
  String? sensorType;
  List<Asset> subAssets = [];

  Asset.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        status = map['status'],
        parentId = map['parentId'],
        locationId = map['locationId'],
        sensorType = map['sensorType'];

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