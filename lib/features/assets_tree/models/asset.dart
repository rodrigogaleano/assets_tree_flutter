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

  bool get isEnergySensor => sensorType == 'energy';

  bool get isCriticalSensor => status == 'alert';
}
