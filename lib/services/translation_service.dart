import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationService {
  // Using Google Translate API (free tier)
  // For production, consider using a paid API with better rate limits
  static const String _baseUrl = 'https://api.mymemory.translated.net/get';

  Future<String> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?q=${Uri.encodeComponent(text)}&langpair=$sourceLanguage|$targetLanguage',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['responseStatus'] == 200) {
          return json['responseData']['translatedText'] ?? text;
        }
      }
      return text;
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }
}
