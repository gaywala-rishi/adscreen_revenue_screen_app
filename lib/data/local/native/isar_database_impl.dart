import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../domain/models/screen_config.dart';
import '../../../domain/models/playlist_content.dart';
import '../../../domain/models/content_play_log.dart';
import 'isar_schemas.dart';

class DatabaseImplementation {
  static late Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ScreenConfigSchemaSchema, PlaylistContentSchemaSchema, ContentPlayLogSchemaSchema],
      directory: dir.path,
    );
  }

  static Future<void> saveConfig(ScreenConfig config) async {
    final schema = ScreenConfigSchema()
      ..screenId = config.screenId
      ..screenToken = config.screenToken
      ..heartbeatIntervalSeconds = config.heartbeatIntervalSeconds
      ..metricsUploadBatchSize = config.metricsUploadBatchSize
      ..syncIntervalMinutes = config.syncIntervalMinutes;
    
    await _isar.writeTxn(() => _isar.screenConfigSchemas.put(schema));
  }

  static Future<ScreenConfig?> getConfig() async {
    final schema = await _isar.screenConfigSchemas.where().findFirst();
    if (schema == null) return null;
    return ScreenConfig(
      id: schema.id,
      screenId: schema.screenId,
      screenToken: schema.screenToken,
      heartbeatIntervalSeconds: schema.heartbeatIntervalSeconds,
      metricsUploadBatchSize: schema.metricsUploadBatchSize,
      syncIntervalMinutes: schema.syncIntervalMinutes,
    );
  }

  static Future<void> updatePlaylist(List<PlaylistContent> contents) async {
    final schemas = contents.map((c) => PlaylistContentSchema()
      ..contentId = c.contentId
      ..url = c.url
      ..type = c.type
      ..durationSeconds = c.durationSeconds
      ..localPath = c.localPath
      ..isDownloaded = c.isDownloaded
      ..regionId = c.regionId
      ..order = c.order
    ).toList();

    await _isar.writeTxn(() async {
      await _isar.playlistContentSchemas.where().deleteAll();
      await _isar.playlistContentSchemas.putAll(schemas);
    });
  }

  static Future<List<PlaylistContent>> getPlaylistForRegion(String regionId) async {
    final schemas = await _isar.playlistContentSchemas
        .filter()
        .regionIdEqualTo(regionId)
        .sortByOrder()
        .findAll();
    
    return schemas.map((s) => PlaylistContent(
      id: s.id,
      contentId: s.contentId,
      url: s.url,
      type: s.type,
      durationSeconds: s.durationSeconds,
      localPath: s.localPath,
      isDownloaded: s.isDownloaded,
      regionId: s.regionId,
      order: s.order,
    )).toList();
  }

  static Future<List<PlaylistContent>> getAllContents() async {
    final schemas = await _isar.playlistContentSchemas.where().findAll();
    return schemas.map((s) => PlaylistContent(
      id: s.id,
      contentId: s.contentId,
      url: s.url,
      type: s.type,
      durationSeconds: s.durationSeconds,
      localPath: s.localPath,
      isDownloaded: s.isDownloaded,
      regionId: s.regionId,
      order: s.order,
    )).toList();
  }

  static Future<void> savePlaylistContent(PlaylistContent content) async {
    final schema = PlaylistContentSchema()
      ..id = content.id ?? Isar.autoIncrement
      ..contentId = content.contentId
      ..url = content.url
      ..type = content.type
      ..durationSeconds = content.durationSeconds
      ..localPath = content.localPath
      ..isDownloaded = content.isDownloaded
      ..regionId = content.regionId
      ..order = content.order;
    
    await _isar.writeTxn(() => _isar.playlistContentSchemas.put(schema));
  }

  static Future<void> logPlay(ContentPlayLog log) async {
    final schema = ContentPlayLogSchema()
      ..contentId = log.contentId
      ..campaignId = log.campaignId
      ..scheduleId = log.scheduleId
      ..layoutRegionId = log.layoutRegionId
      ..playedAt = log.playedAt
      ..durationSeconds = log.durationSeconds
      ..completed = log.completed
      ..errorMessage = log.errorMessage;
    
    await _isar.writeTxn(() => _isar.contentPlayLogSchemas.put(schema));
  }

  static Future<List<ContentPlayLog>> getPendingLogs(int limit) async {
    final schemas = await _isar.contentPlayLogSchemas.where().limit(limit).findAll();
    return schemas.map((s) => ContentPlayLog(
      id: s.id,
      contentId: s.contentId,
      campaignId: s.campaignId,
      scheduleId: s.scheduleId,
      layoutRegionId: s.layoutRegionId,
      playedAt: s.playedAt,
      durationSeconds: s.durationSeconds,
      completed: s.completed,
      errorMessage: s.errorMessage,
    )).toList();
  }

  static Future<void> deleteLogs(List<int> ids) async {
    await _isar.writeTxn(() => _isar.contentPlayLogSchemas.deleteAll(ids));
  }
}
