class PlaylistContent {
  int? id;
  String contentId;
  String url;
  String type; // 'video' or 'image'
  int durationSeconds;
  String? localPath;
  bool isDownloaded;
  String regionId;
  int order;
  String? campaignId;
  String? scheduleId;

  PlaylistContent({
    this.id,
    required this.contentId,
    required this.url,
    required this.type,
    required this.durationSeconds,
    this.localPath,
    this.isDownloaded = false,
    required this.regionId,
    this.order = 0,
    this.campaignId,
    this.scheduleId,
  });
}
