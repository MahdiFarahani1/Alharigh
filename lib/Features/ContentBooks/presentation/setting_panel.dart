import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  double _fontSize = 35;
  String _fontFamily = 'طاهر';
  Color _backgroundColor = Colors.white;

  final List<String> _fontFamilies = ['طاهر', 'البهج', 'دجله'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'حجم الخط',
                style: TextStyle(fontSize: 18),
              ),
              Card(
                color: Colors.black12,
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('ع', style: TextStyle(fontSize: 20)),
                      Expanded(
                        child: SliderTheme(
                          data: const SliderThemeData(
                            inactiveTrackColor: Colors.black12,
                            trackHeight: 2,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 6),
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            value: _fontSize,
                            min: 10,
                            max: 50,
                            divisions: 40,
                            label: _fontSize.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('ع', style: TextStyle(fontSize: 35)),
                    ],
                  ),
                ),
              ),
              EsaySize.gap(20),
              const Text(
                'نوع الخط',
                style: TextStyle(fontSize: 18),
              ),
              EsaySize.gap(10),
              Card(
                color: Colors.black12,
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _fontFamily,
                    items: _fontFamilies.map((font) {
                      return DropdownMenuItem(
                        value: font,
                        child: Text(
                          font,
                          style: TextStyle(fontFamily: font),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _fontFamily = value!;
                      });
                    },
                  ),
                ),
              ),
              EsaySize.gap(20),
              const Text(
                'لون الخلفية',
                style: TextStyle(fontSize: 18),
              ),
              EsaySize.gap(10),
              Card(
                color: Colors.black12,
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: BlocProvider.of<SettingsCubit>(context)
                        .state
                        .backgroundPageColor
                        .map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _backgroundColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              _backgroundColor == color
                                  ? BoxShadow(
                                      offset: const Offset(2, 2),
                                      blurRadius: 5,
                                      color: Theme.of(context)
                                          .floatingActionButtonTheme
                                          .backgroundColor!)
                                  : const BoxShadow(),
                            ],
                            color: color,
                            border: Border.all(
                              color: Colors.black,
                              width: _backgroundColor == color ? 1 : 0.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showFontSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SettingsDialog(),
  );
}
