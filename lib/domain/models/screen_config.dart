class ScreenConfig {
  int? id;
  String screenId;
  String screenToken;
  int heartbeatIntervalSeconds;
  int metricsUploadBatchSize;
  int syncIntervalMinutes;

  ScreenConfig({
    this.id,
    required this.screenId,
    required this.screenToken,
    this.heartbeatIntervalSeconds = 60,
    this.metricsUploadBatchSize = 50,
    this.syncIntervalMinutes = 15,
  });
}
