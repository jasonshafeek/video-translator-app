import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslationService {
  static const String _baseUrl = 'https://api.mymemory.translated.net/get';

  Future<String> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final encodedText = Uri.encodeComponent(text);
    final response = await http
        .get(
          Uri.parse(
            '$_baseUrl?q=$encodedText&langpair=${sourceLanguage}|$targetLanguage',
          ),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['responseStatus'] == 200) {
        return json['responseData']['translatedText'] ?? text;
      }
    }

    return text;
  }
}
