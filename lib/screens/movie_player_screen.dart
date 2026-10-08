import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../providers/translation_provider.dart';
import '../providers/video_provider.dart';
import '../widgets/subtitle_widget.dart';

class MoviePlayerScreen extends StatefulWidget {
  const MoviePlayerScreen({super.key});

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  String _displaySubtitle = '';
  Duration _lastPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    final videoUrl = context.read<VideoProvider>().videoPath;
    if (videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (mounted) setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();
    final translationProvider = context.watch<TranslationProvider>();

    if (videoProvider.videoPath == null) {
      return const Scaffold(
        body: Center(child: Text('No video selected')),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text(videoProvider.videoTitle ?? 'Movie')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final position = _controller!.value.position;
    final subtitleText = _getSubtitleAtPosition(position, translationProvider);
    if (subtitleText != _displaySubtitle && position != _lastPosition) {
      _displaySubtitle = subtitleText;
      _lastPosition = position;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(videoProvider.videoTitle ?? 'Movie'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          if (_displaySubtitle.isNotEmpty)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: SubtitleWidget(subtitle: _displaySubtitle),
              ),
            ),
          if (_showControls)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildControls(translationProvider),
            ),
        ],
      ),
    );
  }

  String _getSubtitleAtPosition(
    Duration position,
    TranslationProvider translationProvider,
  ) {
    final subtitleMap = translationProvider.translatedSubtitles;
    if (subtitleMap.isEmpty) {
      return '';
    }

    final entries = subtitleMap.entries.toList();
    for (final entry in entries) {
      // This is a placeholder mapping and will be replaced by a real subtitle parser later.
      if (entry.key.isNotEmpty) {
        return entry.value;
      }
    }

    return '';
  }

  Widget _buildControls(TranslationProvider translationProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  final pos = _controller!.value.position - const Duration(seconds: 10);
                  _controller!.seekTo(pos);
                },
                icon: const Icon(Icons.replay_10, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                  setState(() {});
                },
                icon: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              IconButton(
                onPressed: () {
                  final pos = _controller!.value.position + const Duration(seconds: 10);
                  _controller!.seekTo(pos);
                },
                icon: const Icon(Icons.forward_10, color: Colors.white),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white30,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Translating ${translationProvider.sourceLanguage.toUpperCase()} → ${translationProvider.targetLanguage.toUpperCase()}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
