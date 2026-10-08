import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class TranslationProvider extends ChangeNotifier {
  final TranslationService _translationService = TranslationService();

  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  bool _isTranslating = false;
  Map<String, String> _translatedSubtitles = {};

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
    } catch (e) {
      _isTranslating = false;
      notifyListeners();
      return text; // Return original if translation fails
    }
  }

  Future<void> translateSubtitles(List<String> subtitles) async {
    _isTranslating = true;
    notifyListeners();

    _translatedSubtitles.clear();

    for (String subtitle in subtitles) {
      try {
        final translated = await translateText(subtitle);
        _translatedSubtitles[subtitle] = translated;
      } catch (e) {
        _translatedSubtitles[subtitle] = subtitle;
      }
    }

    _isTranslating = false;
    notifyListeners();
  }

  void clearTranslations() {
    _translatedSubtitles.clear();
    notifyListeners();
  }
}
