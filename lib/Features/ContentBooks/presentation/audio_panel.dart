import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPanel {
  static void show(BuildContext context,
      {required String bookname, required String url}) {
    final AudioPlayer _audioPlayer = AudioPlayer();
    bool isPlaying = false;
    Duration currentPosition = Duration.zero;
    Duration totalDuration = Duration.zero;
    double volume = 1.0;

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _audioPlayer.onPlayerStateChanged.listen((state) {
              setState(() {
                isPlaying = state == PlayerState.playing;
              });
            });

            _audioPlayer.onDurationChanged.listen((duration) {
              setState(() {
                totalDuration = duration;
              });
            });

            _audioPlayer.onPositionChanged.listen((position) {
              setState(() {
                currentPosition = position;
              });
            });

            String formatDuration(Duration duration) {
              String twoDigits(int n) => n.toString().padLeft(2, '0');
              final hours = duration.inHours;
              final minutes = twoDigits(duration.inMinutes.remainder(60));
              final seconds = twoDigits(duration.inSeconds.remainder(60));

              return hours > 0
                  ? '$hours:$minutes:$seconds' // نمایش ساعت:دقیقه:ثانیه
                  : '$minutes:$seconds'; // نمایش فقط دقیقه:ثانیه
            }

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
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 32),
                        onPressed: () async {
                          if (isPlaying) {
                            await _audioPlayer.pause();
                          } else {
                            await _audioPlayer.setSourceUrl(url);
                            await _audioPlayer.resume();
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.stop, size: 32),
                        onPressed: () async {
                          await _audioPlayer.stop();
                          setState(() {
                            currentPosition = Duration.zero;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(formatDuration(currentPosition)),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                              inactiveTrackColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2)),
                          child: Slider(
                            value: currentPosition.inSeconds.toDouble(),
                            min: 0.0,
                            max: totalDuration.inSeconds.toDouble() > 0
                                ? totalDuration.inSeconds.toDouble()
                                : 1.0,
                            onChanged: (value) async {
                              await _audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                              setState(() {
                                currentPosition =
                                    Duration(seconds: value.toInt());
                              });
                            },
                          ),
                        ),
                      ),
                      Text(formatDuration(totalDuration)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.volume_down),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                              inactiveTrackColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2)),
                          child: Slider(
                            value: volume,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (value) {
                              setState(() {
                                volume = value;
                              });
                              _audioPlayer.setVolume(value);
                            },
                          ),
                        ),
                      ),
                      const Icon(Icons.volume_up),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.stop();
                      _audioPlayer.dispose();
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
}
