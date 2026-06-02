import 'package:flutter/foundation.dart';
import '../local/isar_database_manager.dart';
import '../../core/network/dio_client.dart';

class MetricsBufferManager {
  final DioClient _dioClient = DioClient();
  bool _isSyncing = false;

  Future<void> syncMetrics() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final config = await IsarDatabaseManager.getConfig();
      final batchSize = config?.metricsUploadBatchSize ?? 50;

      final pendingLogs = await IsarDatabaseManager.getPendingLogs(batchSize);
      
      if (pendingLogs.isEmpty) {
        _isSyncing = false;
        return;
      }

      final payload = pendingLogs.map((log) => {
        'contentId': log.contentId,
        'campaignId': log.campaignId,
        'scheduleId': log.scheduleId,
        'regionId': log.layoutRegionId,
        'playedAt': log.playedAt.toIso8601String(),
        'duration': log.durationSeconds,
        'completed': log.completed,
      }).toList();

      final response = await _dioClient.dio.post(
        '/android/screens/MOCK-ID/metrics',
        data: {'logs': payload},
      );

      if (response.statusCode == 200) {
        final idsToDelete = pendingLogs.map((l) => l.id!).toList();
        await IsarDatabaseManager.deleteLogs(idsToDelete);
        debugPrint('Synced ${pendingLogs.length} metrics');
      }
    } catch (e) {
      debugPrint('Metrics sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
