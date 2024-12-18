import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Mixer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioMixerPage(),
    );
  }
}

class AudioMixerPage extends StatefulWidget {
  const AudioMixerPage({super.key});

  @override
  State<AudioMixerPage> createState() => _AudioMixerPageState();
}

class _AudioMixerPageState extends State<AudioMixerPage> {
  final _player1 = AudioPlayer();
  final _player2 = AudioPlayer();
  double _crossfadeValue = 0.5;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _player1
          .setAsset('assets/audio/cinematic-drum-loop-128bpm-240909.mp3');
      await _player2
          .setAsset('assets/audio/latin-percussion-loop-128bpm-240910.mp3');
      _player1.setVolume(0.5);
      _player2.setVolume(0.5);
    } catch (e) {
      debugPrint('Setup error: $e');
    }
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _player1.play();
        _player2.play();
      } else {
        _player1.stop();
        _player2.stop();
      }
    });
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Mixer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: Slider(
                value: _crossfadeValue,
                onChanged: (value) {
                  setState(() {
                    _crossfadeValue = value;
                    _player1.setVolume(1.0 - value);
                    _player2.setVolume(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _togglePlayback,
              child: Text(_isPlaying ? 'Stop' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}
