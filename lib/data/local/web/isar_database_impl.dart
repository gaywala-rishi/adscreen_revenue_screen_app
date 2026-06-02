import '../../../domain/models/screen_config.dart';
import '../../../domain/models/playlist_content.dart';
import '../../../domain/models/content_play_log.dart';

class DatabaseImplementation {
  static Future<void> init() async {
    // No-op for web or use local storage
    print('Database initialized for Web (MOCK)');
  }

  static Future<void> saveConfig(ScreenConfig config) async {}
  static Future<ScreenConfig?> getConfig() async => null;
  
  static Future<void> updatePlaylist(List<PlaylistContent> contents) async {}
  
  static Future<List<PlaylistContent>> getPlaylistForRegion(String regionId) async => [];
  
  static Future<List<PlaylistContent>> getAllContents() async => [];
  
  static Future<void> savePlaylistContent(PlaylistContent content) async {}

  static Future<void> logPlay(ContentPlayLog log) async {}
  
  static Future<List<ContentPlayLog>> getPendingLogs(int limit) async => [];

  static Future<void> deleteLogs(List<int> ids) async {}
}
