import 'package:share_plus/share_plus.dart';

class ShareHelper {
  /// Share plain text (with optional subject)
  static Future<void> shareText(String text, {String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }

  /// Share a single file (with optional caption text/subject/mimeType)
  static Future<void> shareFile(
    String filePath, {
    String? text,
    String? subject,
    String? mimeType,
  }) async {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)], text: text, subject: subject),
    );
  }

  /// Share multiple files
  static Future<void> shareFiles(
    List<String> filePaths, {
    String? text,
    String? subject,
    List<String>? mimeTypes,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: filePaths.map((p) => XFile(p)).toList(),
        text: text,
        subject: subject,
      ),
    );
  }
}
