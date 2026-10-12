import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_video_encoder/story_video_encoder.dart';

import 'demo_encoder.dart';

void main() => runApp(const MaterialApp(home: EncoderDemoPage()));

class EncoderDemoPage extends StatefulWidget {
  const EncoderDemoPage({super.key});

  @override
  State<EncoderDemoPage> createState() => _EncoderDemoPageState();
}

enum _Variant { silent, music, musicFade }

class _EncoderDemoPageState extends State<EncoderDemoPage> {
  bool _busy = false;
  bool _cancelRequested = false;
  double _progress = 0;
  String _status = 'Encodes 5 s of 1080×1920 animated gradient at 30 fps.';
  String? _resultPath;

  Future<void> _encode(_Variant variant) async {
    setState(() {
      _busy = true;
      _cancelRequested = false;
      _progress = 0;
      _resultPath = null;
      _status = 'Encoding…';
    });
    try {
      final audio = variant == _Variant.silent ? null : await extractTestTone();
      final result = await encodeDemo(
        outputPath: '${Directory.systemTemp.path}/story_demo_${variant.name}.mp4',
        audioPath: audio,
        audioStart: audio == null ? null : const Duration(milliseconds: 500),
        fadeOut: variant == _Variant.musicFade ? const Duration(seconds: 2) : null,
        onProgress: (done, total) => setState(() => _progress = done / total),
        shouldCancel: () => _cancelRequested,
      );
      setState(() {
        _resultPath = result.path;
        _status = result.toString();
      });
    } on StoryVideoException catch (e) {
      setState(() => _status = 'Failed: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('story_video_encoder')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (variant, label) in [
            (_Variant.silent, 'Encode video only'),
            (_Variant.music, 'Encode with music'),
            (_Variant.musicFade, 'Encode with music + 2 s fade-out'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilledButton(
                onPressed: _busy ? null : () => _encode(variant),
                child: Text(label),
              ),
            ),
          if (_busy) ...[
            LinearProgressIndicator(value: _progress),
            TextButton(
              onPressed: () => setState(() => _cancelRequested = true),
              child: const Text('Cancel'),
            ),
          ],
          const SizedBox(height: 16),
          SelectableText(_status),
          if (_resultPath != null)
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy path'),
              onPressed: () => Clipboard.setData(ClipboardData(text: _resultPath!)),
            ),
        ],
      ),
    );
  }
}
