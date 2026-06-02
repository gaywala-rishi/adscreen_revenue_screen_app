class ContentPlayLog {
  int? id;
  String contentId;
  String campaignId;
  String scheduleId;
  String layoutRegionId;
  DateTime playedAt;
  int durationSeconds;
  bool completed;
  String? errorMessage;

  ContentPlayLog({
    this.id,
    required this.contentId,
    required this.campaignId,
    required this.scheduleId,
    required this.layoutRegionId,
    required this.playedAt,
    required this.durationSeconds,
    this.completed = true,
    this.errorMessage,
  });
}
