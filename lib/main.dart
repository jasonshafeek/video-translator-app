import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/translation_provider.dart';
import 'providers/video_provider.dart';
import 'screens/home_screen.dart';
import 'screens/movie_player_screen.dart';

void main() {
  runApp(const VideoTranslatorApp());
}

class VideoTranslatorApp extends StatelessWidget {
  const VideoTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
      ],
      child: MaterialApp(
        title: 'Video Translator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/player': (context) => const MoviePlayerScreen(),
        },
      ),
    );
  }
}
