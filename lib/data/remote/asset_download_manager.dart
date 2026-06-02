import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../local/isar_database_manager.dart';
import '../../domain/models/playlist_content.dart';

class AssetDownloadManager {
  final Dio _dio = Dio();
  
  // Semaphore-like control for concurrency
  int _activeDownloads = 0;
  static const int maxConcurrentDownloads = 2;

  Future<void> syncAssets() async {
    final contents = (await IsarDatabaseManager.getAllContents()).where((c) => !c.isDownloaded).toList();
    
    for (var content in contents) {
      while (_activeDownloads >= maxConcurrentDownloads) {
        await Future.delayed(const Duration(seconds: 1));
      }
      _downloadAsset(content);
    }
  }

  Future<void> _downloadAsset(PlaylistContent content) async {
    _activeDownloads++;
    try {
      final appDir = await getApplicationSupportDirectory();
      final assetsDir = Directory('${appDir.path}/assets');
      if (!await assetsDir.exists()) {
        await assetsDir.create(recursive: true);
      }

      final fileName = content.url.split('/').last;
      final savePath = '${assetsDir.path}/$fileName';

      await _dio.download(
        content.url,
        savePath,
      );

      final file = File(savePath);
      if (await file.exists() && await file.length() > 0) {
        content.localPath = savePath;
        content.isDownloaded = true;
        
        await IsarDatabaseManager.savePlaylistContent(content);
        print('Downloaded: ${content.url}');
      }
    } catch (e) {
      print('Download failed for ${content.url}: $e');
    } finally {
      _activeDownloads--;
    }
  }

  Future<void> pruneOldAssets() async {
    final appDir = await getApplicationSupportDirectory();
    final assetsDir = Directory('${appDir.path}/assets');
    if (!await assetsDir.exists()) return;

    final activeContents = await IsarDatabaseManager.getAllContents();
    final activePaths = activeContents.map((c) => c.localPath).toSet();

    await for (var entity in assetsDir.list()) {
      if (entity is File && !activePaths.contains(entity.path)) {
        await entity.delete();
        print('Pruned stale asset: ${entity.path}');
      }
    }
  }
}
