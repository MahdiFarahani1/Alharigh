import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SettingsDialog extends StatelessWidget {
  final InAppWebViewController? controller;
  const SettingsDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    String _fontFamily =
        BlocProvider.of<SettingsCubit>(context).state.selectedFont;

    final List<String> _fontFamilies = ['بهیج', 'نازنین', 'نسخ'];
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
                          child: BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, state) {
                              return Slider(
                                value: state.fontSize,
                                min: 10,
                                max: 30,
                                divisions: 20,
                                label: state.fontSize.round().toString(),
                                onChanged: (size) {
                                  print('______${size}___________');
                                  BlocProvider.of<SettingsCubit>(context)
                                      .changeFontSize(
                                    size,
                                  );
                                },
                              );
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
                      BlocProvider.of<SettingsCubit>(context)
                          .changeFont(value!);
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
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return Card(
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
                              BlocProvider.of<SettingsCubit>(context)
                                  .changePageColor(color);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  state.selectedPageColor == color
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
                                  width: state.selectedPageColor == color
                                      ? 1
                                      : 0.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showFontSettingsDialog(
    BuildContext context, InAppWebViewController controller) {
  showDialog(
    context: context,
    builder: (context) => SettingsDialog(
      controller: controller,
    ),
  );
}
