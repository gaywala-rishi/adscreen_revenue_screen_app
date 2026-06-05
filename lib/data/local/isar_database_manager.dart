import 'native/isar_database_impl.dart' if (dart.library.html) 'web/isar_database_impl.dart' as impl;
import '../../domain/models/screen_config.dart';
import '../../domain/models/playlist_content.dart';
import '../../domain/models/content_play_log.dart';

class IsarDatabaseManager {
  static Future<void> init() => impl.DatabaseImplementation.init();

  static Future<void> saveConfig(ScreenConfig config) => impl.DatabaseImplementation.saveConfig(config);
  static Future<ScreenConfig?> getConfig() => impl.DatabaseImplementation.getConfig();

  static Future<void> updatePlaylist(List<PlaylistContent> contents) => impl.DatabaseImplementation.updatePlaylist(contents);
  static Future<List<PlaylistContent>> getPlaylistForRegion(String regionId) => impl.DatabaseImplementation.getPlaylistForRegion(regionId);
  static Future<List<PlaylistContent>> getAllContents() => impl.DatabaseImplementation.getAllContents();
  static Future<void> savePlaylistContent(PlaylistContent content) => impl.DatabaseImplementation.savePlaylistContent(content);

  static Future<void> logPlay(ContentPlayLog log) => impl.DatabaseImplementation.logPlay(log);
  static Future<List<ContentPlayLog>> getPendingLogs(int limit) => impl.DatabaseImplementation.getPendingLogs(limit);
  static Future<void> deleteLogs(List<int> ids) => impl.DatabaseImplementation.deleteLogs(ids);
  static Future<void> clearDatabase() => impl.DatabaseImplementation.clearDatabase();
}
