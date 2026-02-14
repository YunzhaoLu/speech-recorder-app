import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'recorder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recorder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const RecorderPage(),
    );
  }
}

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final RecorderManager _recorder = RecorderManager();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _currentPath;
  List<Recording> _recordings = [];
  bool _isPlaying = false;
  String? _playingPath;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _loadRecordings() async {
    final recordings = await _recorder.getRecordings();
    setState(() {
      _recordings = recordings;
    });
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _recorder.stopRecording();
      setState(() {
        _isRecording = false;
        _currentPath = null;
      });
      await _loadRecordings();
    } else {
      await _audioPlayer.stop();

      final path = await _recorder.startRecording();
      if (path != null) {
        setState(() {
          _isRecording = true;
          _currentPath = path;
          _playingPath = null;
        });
        await _audioPlayer.stop();
      }
    }
  }

  Future<void> _playRecording(String path) async {
    if (_playingPath == path) {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else if (_audioPlayer.state == PlayerState.paused) {
        await _audioPlayer.resume();
        setState(() => _isPlaying = true);
      }
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(path));
      setState(() {
        _playingPath = path;
        _isPlaying = true;
        _isRecording = false;
      });
    }
  }

  Future<void> _pauseRecording() async {
    // Add pause/resume functionality if needed
    setState(() => _isRecording = !_isRecording);
  }

  Future<void> _deleteRecording(String path) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recording'),
        content: const Text('Are you sure you want to delete this recording?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _recorder.deleteRecording(path);
      setState(() {
        _recordings.removeWhere((r) => r.path == path);
        if (_playingPath == path) {
          _playingPath = null;
          _isPlaying = false;
        }
      });
      await _loadRecordings();
    }
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  Future<void> _shareRecording(Recording recording) async {
    // In a real app, you would implement cloud sharing here
    final actionSheet = showBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share via Cloud'),
              onTap: () {
                Navigator.pop(context);
                _showShareDialog(recording);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Path'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: recording.path));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Path copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Show Info'),
              onTap: () {
                Navigator.pop(context);
                _showRecordingInfo(recording);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_open),
              title: const Text('Open in File Manager'),
              onTap: () {
                Navigator.pop(context);
                // On Android, you can use path_provider to show the file
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Path: ${recording.path}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('App Settings'),
              onTap: () {
                Navigator.pop(context);
                _openSettings();
              },
            ),
            const ListTile(
              leading: Icon(Icons.close),
              title: Text('Cancel'),
              onTap: null,
            ),
          ],
        ),
      ),
    );

    await actionSheet;
  }

  void _showRecordingInfo(Recording recording) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recording Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File name: ${recording.fileName}'),
            const SizedBox(height: 8),
            Text('Size: ${recording.formattedSize}'),
            const SizedBox(height: 8),
            Text('Date: ${recording.formattedDate}'),
            const SizedBox(height: 8),
            Text('Path: ${recording.path}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(Recording recording) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Recording'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File: ${recording.fileName}'),
            const SizedBox(height: 8),
            Text('Size: ${recording.formattedSize}'),
            const SizedBox(height: 16),
            Text('Note: In a real app, you would integrate cloud storage\n'
                'like Aliyun OSS, AWS S3, or Cloudinary here.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing feature coming soon!')),
              );
            },
            child: const Text('Upload to Cloud'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Recording controls
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? Colors.red : Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording ? Colors.red : Colors.green)
                              .withOpacity(0.5),
                          spreadRadius: 8,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_isRecording)
                  Text(
                    'Recording...',
                    style: Theme.of(context).textTheme.titleLarge.copyWith(
                      color: _isRecording ? Colors.red : Colors.green,
                    ),
                  )
                else
                  Text(
                    'Tap to record',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                const SizedBox(height: 8),
                if (_isRecording)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: LinearProgressIndicator(
                      value: null,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  ),
              ],
            ),
          ),

          // Recordings list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: _recordings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_none,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recordings yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the button to start recording',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _recordings.length,
                      itemBuilder: (context, index) {
                        final recording = _recordings[index];
                        final isPlaying = _playingPath == recording.path;
                        final isCurrentRecording = _currentPath == recording.path;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: isPlaying ? 4 : 1,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isPlaying
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlaying ? Icons.music_note : Icons.mic,
                                color: isPlaying ? Colors.blue : Colors.green,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              recording.fileName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${recording.formattedDate} • ${recording.formattedSize}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (isPlaying)
                                  const Text(
                                    'Playing...',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: isPlaying ? Colors.blue : Colors.green,
                                  ),
                                  onPressed: () => _playRecording(recording.path),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () => _shareRecording(recording),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _deleteRecording(recording.path),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
