class LayoutConfig {
  final String id;
  final String name;
  final List<LayoutRegion> regions;

  LayoutConfig({required this.id, required this.name, required this.regions});

  factory LayoutConfig.fromJson(Map<String, dynamic> json) {
    return LayoutConfig(
      id: json['id'],
      name: json['name'],
      regions: (json['regions'] as List).map((r) => LayoutRegion.fromJson(r)).toList(),
    );
  }
}

class LayoutRegion {
  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  final String type;

  LayoutRegion({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.type,
  });

  factory LayoutRegion.fromJson(Map<String, dynamic> json) {
    return LayoutRegion(
      id: json['id'],
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      type: json['type'],
    );
  }
}
