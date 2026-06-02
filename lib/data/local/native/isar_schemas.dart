import 'package:isar/isar.dart';

part 'isar_schemas.g.dart';

@Collection()
class ScreenConfigSchema {
  Id id = Isar.autoIncrement;

  late String screenId;
  late String screenToken;
  
  int heartbeatIntervalSeconds = 60;
  int metricsUploadBatchSize = 50;
  int syncIntervalMinutes = 15;
}

@Collection()
class PlaylistContentSchema {
  Id id = Isar.autoIncrement;

  late String contentId;
  late String url;
  late String type; // 'video' or 'image'
  late int durationSeconds;
  
  String? localPath;
  bool isDownloaded = false;
  
  @Index()
  late String regionId; // e.g., 'AD_1', 'AD_2'
  
  int order = 0;
}

@Collection()
class ContentPlayLogSchema {
  Id id = Isar.autoIncrement;

  late String contentId;
  late String campaignId;
  late String scheduleId;
  late String layoutRegionId;
  
  @Index()
  late DateTime playedAt;
  
  late int durationSeconds;
  bool completed = true;
  String? errorMessage;
}
