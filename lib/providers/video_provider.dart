import 'package:flutter/material.dart';

class VideoProvider extends ChangeNotifier {
  String? _videoPath;
  String? _videoTitle;
  String? _videoUrl;

  String? get videoPath => _videoPath;
  String? get videoTitle => _videoTitle;
  String? get videoUrl => _videoUrl;

  void setVideo({
    required String path,
    required String title,
    String? url,
  }) {
    _videoPath = path;
    _videoTitle = title;
    _videoUrl = url;
    notifyListeners();
  }

  void clearVideo() {
    _videoPath = null;
    _videoTitle = null;
    _videoUrl = null;
    notifyListeners();
  }
}
