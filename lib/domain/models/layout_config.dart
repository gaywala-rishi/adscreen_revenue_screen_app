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
  final bool hasAudio;

  LayoutRegion({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.type,
    this.hasAudio = false,
  });

  factory LayoutRegion.fromJson(Map<String, dynamic> json) {
    return LayoutRegion(
      id: json['id'] ?? json['code'] ?? '',
      x: ((json['x'] ?? json['xPos'] ?? 0.0) as num).toDouble(),
      y: ((json['y'] ?? json['yPos'] ?? 0.0) as num).toDouble(),
      width: ((json['width'] ?? 1.0) as num).toDouble(),
      height: ((json['height'] ?? 1.0) as num).toDouble(),
      type: json['type'] ?? json['code'] ?? 'image',
      hasAudio: json['hasAudio'] ?? false,
    );
  }
}
