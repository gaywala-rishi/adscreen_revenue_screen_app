import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../data/local/isar_database_manager.dart';
import '../../domain/models/playlist_content.dart';
import '../../domain/models/content_play_log.dart';

class ZonePlayerFrame extends StatefulWidget {
  final String regionId;
  const ZonePlayerFrame({super.key, required this.regionId});

  @override
  State<ZonePlayerFrame> createState() => _ZonePlayerFrameState();
}

class _ZonePlayerFrameState extends State<ZonePlayerFrame> {
  List<PlaylistContent> _playlist = [];
  int _currentIndex = 0;
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  StreamSubscription? _youtubeSubscription;
  Timer? _imageTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    final contents = await IsarDatabaseManager.getPlaylistForRegion(widget.regionId);
    if (mounted) {
      setState(() {
        _playlist = contents;
        _isLoading = false;
        if (_playlist.isNotEmpty) {
          _playCurrent();
        }
      });
    }
  }

  Future<void> _playCurrent() async {
    if (_playlist.isEmpty) return;
    
    final content = _playlist[_currentIndex];
    
    if (content.type == 'video') {
      await _playVideo(content);
    } else if (content.type == 'youtube_url') {
      await _playYoutube(content);
    } else {
      _playImage(content);
    }
  }

  Future<void> _playVideo(PlaylistContent content) async {
    _videoController?.dispose();
    
    // Prefer local file if downloaded
    if (content.isDownloaded && content.localPath != null) {
      _videoController = VideoPlayerController.file(File(content.localPath!));
    } else {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(content.url));
    }

    try {
      await _videoController!.initialize();
      if (mounted) {
        setState(() {});
        _videoController!.play();
        _videoController!.addListener(_videoListener);
      }
    } catch (e) {
      debugPrint('Video Error in ${widget.regionId}: $e');
      _next();
    }
  }

  void _videoListener() {
    if (_videoController!.value.position >= _videoController!.value.duration) {
      _videoController!.removeListener(_videoListener);
      _next();
    }
  }

  Future<void> _playYoutube(PlaylistContent content) async {
    _youtubeSubscription?.cancel();
    _youtubeSubscription = null;
    _youtubeController?.close();
    _youtubeController = null;

    final videoId = YoutubePlayerController.convertUrlToId(content.url);
    if (videoId == null) {
      debugPrint('Invalid YouTube URL: ${content.url}');
      _next();
      return;
    }

    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        mute: false,
      ),
    );

    _youtubeSubscription = _youtubeController!.listen((value) {
      if (value.playerState == PlayerState.ended) {
        _youtubeSubscription?.cancel();
        _next();
      }
    });

    if (mounted) setState(() {});
  }

  void _playImage(PlaylistContent content) {
    _imageTimer?.cancel();
    _imageTimer = Timer(Duration(seconds: content.durationSeconds), () {
      _next();
    });
    if (mounted) setState(() {});
  }

  void _next() {
    if (_playlist.isEmpty) return;
    
    // Log the play
    final playedContent = _playlist[_currentIndex];
    IsarDatabaseManager.logPlay(ContentPlayLog(
      contentId: playedContent.contentId,
      campaignId: 'MOCK-CAMP',
      scheduleId: 'MOCK-SCHED',
      layoutRegionId: widget.regionId,
      playedAt: DateTime.now(),
      durationSeconds: playedContent.durationSeconds,
    ));

    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _videoController = null;

    _youtubeSubscription?.cancel();
    _youtubeSubscription = null;
    _youtubeController?.close();
    _youtubeController = null;

    _imageTimer?.cancel();
    _imageTimer = null;

    setState(() {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    });
    _playCurrent();
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _youtubeSubscription?.cancel();
    _youtubeController?.close();
    _imageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_playlist.isEmpty) {
      return Container(
        color: Colors.black26,
        child: const Center(child: Icon(Icons.broken_image, color: Colors.white24)),
      );
    }

    final content = _playlist[_currentIndex];

    Widget playerWidget;
    if (content.type == 'video') {
      playerWidget = _videoController != null && _videoController!.value.isInitialized
          ? FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            )
          : const Center(child: CircularProgressIndicator());
    } else if (content.type == 'youtube_url') {
      playerWidget = _youtubeController != null
          ? IgnorePointer(
              child: YoutubePlayer(
                controller: _youtubeController!,
              ),
            )
          : const Center(child: CircularProgressIndicator());
    } else {
      playerWidget = content.isDownloaded && content.localPath != null
          ? Image.file(File(content.localPath!), fit: BoxFit.fill, width: double.infinity, height: double.infinity)
          : CachedNetworkImage(
              imageUrl: content.url,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            );
    }

    return Container(
      color: Colors.black,
      child: playerWidget,
    );
  }
}
