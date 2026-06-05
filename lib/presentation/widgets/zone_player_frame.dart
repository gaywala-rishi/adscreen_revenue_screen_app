import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../data/local/isar_database_manager.dart';
import '../../domain/models/playlist_content.dart';
import '../../domain/models/content_play_log.dart';
import '../../main.dart';

class ZonePlayerFrame extends StatefulWidget {
  final String regionId;
  final bool isMuted;
  const ZonePlayerFrame({
    super.key, 
    required this.regionId,
    this.isMuted = false,
  });

  @override
  State<ZonePlayerFrame> createState() => _ZonePlayerFrameState();
}

class _ZonePlayerFrameState extends State<ZonePlayerFrame> with RouteAware, WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
    _loadPlaylist();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and the current route shows up.
    if (_playlist.isNotEmpty && _playlist[_currentIndex].type == 'youtube_url') {
      debugPrint('[ZonePlayerFrame] Resuming YouTube on navigation back in ${widget.regionId}');
      _youtubeController?.playVideo();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_playlist.isNotEmpty && _playlist[_currentIndex].type == 'youtube_url') {
        debugPrint('[ZonePlayerFrame] Resuming YouTube on app resume in ${widget.regionId}');
        _youtubeController?.playVideo();
      }
    }
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
        _videoController!.setVolume(widget.isMuted ? 0 : 1.0);
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
      params: YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        playsInline: true,
        mute: widget.isMuted,
        pointerEvents: PointerEvents.none,
        strictRelatedVideos: true,
        showVideoAnnotations: false,
      ),
    );

    // Force exit fullscreen if it somehow gets triggered (fail-safe)
    _youtubeController!.setFullScreenListener((isFullScreen) {
      if (isFullScreen) {
        _youtubeController!.exitFullScreen();
      }
    });

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
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
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
                key: ValueKey(content.contentId),
                controller: _youtubeController!,
                aspectRatio: 16 / 9,
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
