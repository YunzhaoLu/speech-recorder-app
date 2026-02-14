import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioRecorder {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<String?> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${directory.path}/recordings');
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }
      final path = '${recordingsDir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(path);
      return path;
    }
    return null;
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
  }

  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }

  Future<void> deleteRecording(String path) async {
    if (await File(path).exists()) {
      await File(path).delete();
    }
  }

  Future<List<Recording>> getRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/recordings');

    if (!await recordingsDir.exists()) {
      return [];
    }

    final files = recordingsDir.listSync();
    return files
        .where((f) => f.path.endsWith('.m4a'))
        .map((f) => Recording(
              path: f.path,
              fileName: f.path.split('/').last,
              lastModified: f.lastModifiedSync(),
              sizeBytes: f.statSync().size,
            ))
        .toList()
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  Future<File> getAudioFile(String path) async {
    return File(path);
  }

  void dispose() {
    _recorder.dispose();
  }
}

class Recording {
  final String path;
  final String fileName;
  final DateTime lastModified;
  final int sizeBytes;

  Recording({
    required this.path,
    required this.fileName,
    required this.lastModified,
    required this.sizeBytes,
  });

  String get formattedSize {
    final kb = sizeBytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  String get formattedDate {
    return '${lastModified.year}-${lastModified.month.toString().padLeft(2, '0')}-${lastModified.day.toString().padLeft(2, '0')} '
           '${lastModified.hour.toString().padLeft(2, '0')}:${lastModified.minute.toString().padLeft(2, '0')}';
  }
}
