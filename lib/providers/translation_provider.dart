import 'package:flutter/material.dart';

import '../services/translation_service.dart';

class TranslationProvider extends ChangeNotifier {
  final TranslationService _translationService = TranslationService();

  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  bool _isTranslating = false;
  final Map<String, String> _translatedSubtitles = {};

  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;
  bool get isTranslating => _isTranslating;
  Map<String, String> get translatedSubtitles => _translatedSubtitles;

  void setSourceLanguage(String language) {
    _sourceLanguage = language;
    notifyListeners();
  }

  void setTargetLanguage(String language) {
    _targetLanguage = language;
    notifyListeners();
  }

  Future<String> translateText(String text) async {
    if (text.trim().isEmpty) {
      return text;
    }

    _isTranslating = true;
    notifyListeners();

    try {
      final translated = await _translationService.translate(
        text: text,
        sourceLanguage: _sourceLanguage,
        targetLanguage: _targetLanguage,
      );
      _isTranslating = false;
      notifyListeners();
      return translated;
    } catch (_) {
      _isTranslating = false;
      notifyListeners();
      return text;
    }
  }

  Future<void> translateSubtitles(List<String> subtitles) async {
    _isTranslating = true;
    notifyListeners();
    _translatedSubtitles.clear();

    for (final subtitle in subtitles) {
      final translated = await translateText(subtitle);
      _translatedSubtitles[subtitle] = translated;
    }

    _isTranslating = false;
    notifyListeners();
  }

  void clearTranslations() {
    _translatedSubtitles.clear();
    notifyListeners();
  }
}
