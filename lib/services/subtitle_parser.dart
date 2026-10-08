import '../models/subtitle_item.dart';

class SubtitleParser {
  static List<SubtitleItem> parseSrt(String rawText) {
    final normalized = rawText.replaceAll('\r\n', '\n').trim();
    if (normalized.isEmpty) return const [];

    final blocks = normalized.split('\n\n');
    final subtitles = <SubtitleItem>[];

    for (final block in blocks) {
      final lines = block
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (lines.length < 3) continue;

      final timeLine = lines[1];
      final match = RegExp(
        r'(\d{2}:\d{2}:\d{2},\d{1,3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{1,3})',
      ).firstMatch(timeLine);

      if (match == null) continue;

      final start = _parseTimestamp(match.group(1)!);
      final end = _parseTimestamp(match.group(2)!);
      final text = lines.sublist(2).join('\n');

      subtitles.add(
        SubtitleItem(
          start: start,
          end: end,
          text: text,
        ),
      );
    }

    return subtitles;
  }

  static Duration _parseTimestamp(String value) {
    final parts = value.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secondsAndMs = parts[2].split(',');
    final seconds = int.parse(secondsAndMs[0]);
    final milliseconds = int.parse(secondsAndMs[1]);

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }
}
