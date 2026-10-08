import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../providers/translation_provider.dart';
import '../widgets/subtitle_widget.dart';

class MoviePlayerScreen extends StatefulWidget {
  const MoviePlayerScreen({Key? key}) : super(key: key);

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  late VideoPlayerController _videoController;
  bool _showControls = true;
  String _currentSubtitle = '';

  @override
  void initState() {
    super.initState();
    final videoPath = context.read<VideoProvider>().videoPath;
    
    if (videoPath != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoPath))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();
    final translationProvider = context.watch<TranslationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(videoProvider.videoTitle ?? 'Video Player'),
      ),
      body: Stack(
        children: [
          // Video Player
          GestureDetector(
            onTap: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
            child: Center(
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_videoController),
                          // Subtitles Overlay
                          if (_currentSubtitle.isNotEmpty)
                            Positioned(
                              bottom: 60,
                              left: 0,
                              right: 0,
                              child: SubtitleWidget(
                                subtitle: _currentSubtitle,
                              ),
                            ),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
          // Video Controls
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildVideoControls(translationProvider),
            ),
          // Loading indicator during translation
          if (translationProvider.isTranslating)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoControls(TranslationProvider translationProvider) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Language info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Translating: ${translationProvider.sourceLanguage.toUpperCase()} → ${translationProvider.targetLanguage.toUpperCase()}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  _videoController.seekTo(
                    _videoController.value.position - const Duration(seconds: 10),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _videoController.value.isPlaying
                        ? _videoController.pause()
                        : _videoController.play();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  _videoController.seekTo(
                    _videoController.value.position + const Duration(seconds: 10),
                  );
                },
              ),
            ],
          ),
          // Progress bar
          VideoProgressIndicator(
            _videoController,
            allowScrubbing: true,
          ),
        ],
      ),
    );
  }
}
