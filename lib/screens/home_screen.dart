import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../providers/translation_provider.dart';
import 'movie_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _sampleVideos = [
    {
      'title': 'Sample Movie 1',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-library/sample/BigBuckBunny.mp4',
      'poster': 'https://via.placeholder.com/300x400?text=Big+Buck+Bunny',
    },
    {
      'title': 'Sample Movie 2',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-library/sample/ElephantsDream.mp4',
      'poster': 'https://via.placeholder.com/300x400?text=Elephant+Dream',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Translator'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Language Selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<TranslationProvider>(
              builder: (context, translationProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subtitle Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('From:'),
                              DropdownButton<String>(
                                value: translationProvider.sourceLanguage,
                                onChanged: (value) {
                                  if (value != null) {
                                    translationProvider.setSourceLanguage(value);
                                  }
                                },
                                items: const [
                                  DropdownMenuItem(value: 'en', child: Text('English')),
                                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                                  DropdownMenuItem(value: 'fr', child: Text('French')),
                                  DropdownMenuItem(value: 'de', child: Text('German')),
                                  DropdownMenuItem(value: 'it', child: Text('Italian')),
                                  DropdownMenuItem(value: 'pt', child: Text('Portuguese')),
                                  DropdownMenuItem(value: 'ja', child: Text('Japanese')),
                                  DropdownMenuItem(value: 'zh-CN', child: Text('Chinese')),
                                  DropdownMenuItem(value: 'ru', child: Text('Russian')),
                                  DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('To:'),
                              DropdownButton<String>(
                                value: translationProvider.targetLanguage,
                                onChanged: (value) {
                                  if (value != null) {
                                    translationProvider.setTargetLanguage(value);
                                  }
                                },
                                items: const [
                                  DropdownMenuItem(value: 'en', child: Text('English')),
                                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                                  DropdownMenuItem(value: 'fr', child: Text('French')),
                                  DropdownMenuItem(value: 'de', child: Text('German')),
                                  DropdownMenuItem(value: 'it', child: Text('Italian')),
                                  DropdownMenuItem(value: 'pt', child: Text('Portuguese')),
                                  DropdownMenuItem(value: 'ja', child: Text('Japanese')),
                                  DropdownMenuItem(value: 'zh-CN', child: Text('Chinese')),
                                  DropdownMenuItem(value: 'ru', child: Text('Russian')),
                                  DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          // Sample Videos List
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Available Movies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sampleVideos.length,
            itemBuilder: (context, index) {
              final video = _sampleVideos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<VideoProvider>().setVideo(
                          path: video['url']!,
                          title: video['title']!,
                          url: video['url'],
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoviePlayerScreen(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Image.network(
                          video['poster']!,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.movie),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tap to play with translations',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.play_arrow, color: Colors.blue),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
