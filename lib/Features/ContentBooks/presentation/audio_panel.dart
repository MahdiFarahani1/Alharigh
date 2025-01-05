import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPanel {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static void show(BuildContext context,
      {required String bookname, required String url}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            double currentVolume = 1.0;

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    bookname,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow, size: 32),
                        onPressed: () async {
                          await _audioPlayer.setUrl(url);
                          await _audioPlayer.play();
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.pause, size: 32),
                        onPressed: () async {
                          await _audioPlayer.pause();
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 32),
                        onPressed: () async {
                          await _audioPlayer.play();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text('00.00'),
                      StreamBuilder<Duration?>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final totalDuration =
                              _audioPlayer.duration ?? Duration.zero;

                          return Expanded(
                            child: SliderTheme(
                              data: const SliderThemeData(
                                inactiveTrackColor: Colors.grey,
                                trackHeight: 2.5,
                                thumbShape: RoundSliderThumbShape(
                                  disabledThumbRadius: 6.5,
                                  enabledThumbRadius: 6.5,
                                ),
                              ),
                              child: Slider(
                                value: position.inMilliseconds.toDouble(),
                                min: 0.0,
                                max: totalDuration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _audioPlayer.seek(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Text('00.00'),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.volume_down),
                      Expanded(
                        child: StreamBuilder<double>(
                          stream: _audioPlayer.volumeStream,
                          initialData: currentVolume,
                          builder: (context, snapshot) {
                            final volume = snapshot.data ?? 1.0;
                            return SliderTheme(
                              data: const SliderThemeData(
                                inactiveTrackColor: Colors.grey,
                                trackHeight: 2.5,
                                thumbShape: RoundSliderThumbShape(
                                  disabledThumbRadius: 6.5,
                                  enabledThumbRadius: 6.5,
                                ),
                              ),
                              child: Slider(
                                value: volume,
                                min: 0.0,
                                max: 1.0,
                                onChanged: (value) {
                                  _audioPlayer.setVolume(value);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Icon(Icons.volume_up),
                    ],
                  ),

                  // Close Button
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("اغلاق"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void dispose() {
    _audioPlayer.dispose();
  }
}
