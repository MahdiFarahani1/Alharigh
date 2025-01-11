import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/common/common_snackBar.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/widgets/divider.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> themeColor = [
      Colors.blue,
      Colors.brown.shade400,
      Colors.grey,
      Colors.green,
      Colors.indigo.shade400
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'الإعدادات',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionTitle('الألوان:'),
                EsaySize.gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: themeColor
                      .map(
                        (col) => _buildColorOption(context, col, state),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                CustomDivider.divier(),
                _buildSectionTitle('حجم الخط:'),
                Row(
                  children: [
                    const Icon(Icons.text_fields),
                    Expanded(
                      child: SliderTheme(
                        data: themeSlider(),
                        child: Slider(
                          value: state.fontSize,
                          min: 10,
                          max: 30,
                          divisions: 20,
                          label: state.fontSize.toString(),
                          onChanged: (size) {
                            cubit.changeFontSize(
                              size,
                            );
                          },
                        ),
                      ),
                    ),
                    Text(state.fontSize.toStringAsFixed(0)),
                  ],
                ),
                const SizedBox(height: 16),
                CustomDivider.divier(),
                _buildSectionTitle('تباعد الأسطر:'),
                Row(
                  children: [
                    const Icon(Icons.format_line_spacing),
                    Expanded(
                      child: SliderTheme(
                        data: themeSlider(),
                        child: Slider(
                          value: state.lineSpacing,
                          min: 30,
                          max: 60,
                          divisions: 30,
                          label: state.lineSpacing.toStringAsFixed(1),
                          onChanged: cubit.changeLineSpacing,
                        ),
                      ),
                    ),
                    Text(state.lineSpacing.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 16),
                CustomDivider.divier(),
                _buildSectionTitle('نوع الخط:'),
                DropdownButton<String>(
                  value: state.selectedFont,
                  items: ['بهیج', 'نازنین', 'نسخ'].map((font) {
                    return DropdownMenuItem(value: font, child: Text(font));
                  }).toList(),
                  onChanged: (value) {
                    cubit.changeFont(value!);
                  },
                ),
                const SizedBox(height: 16),
                CustomDivider.divier(),
                _buildSectionTitle('لون الخلفية:'),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: BlocProvider.of<SettingsCubit>(context)
                        .state
                        .backgroundPageColor
                        .map(
                      (color) {
                        return _buildBackgroundOption(context, color, state);
                      },
                    ).toList()),
                const SizedBox(height: 16),
                CustomDivider.divier(),
                _buildSectionTitle('الوضع الليلي:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.moon),
                    EsaySize.gap(8),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        return Transform.scale(
                          scale: 0.75,
                          child: Switch(
                            value: state.isLightMode,
                            onChanged: (value) {
                              BlocProvider.of<SettingsCubit>(context)
                                  .changeThemeMode(value);
                            },
                            activeColor: Colors.amber,
                            inactiveTrackColor: Colors.grey.shade700,
                            inactiveThumbColor: Colors.grey.shade900,
                          ),
                        );
                      },
                    ),
                    EsaySize.gap(8),
                    const Icon(FontAwesomeIcons.sun),
                  ],
                ),
                const SizedBox(height: 16),
                CustomDivider.divier(),
                _buildSectionTitle('عرض الصفحة:'),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('عرض صفحة صفحة'),
                      value: 'افقی',
                      groupValue: state.pageOrientation,
                      onChanged: (value) {
                        cubit.changePageOrientation(value!);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('عرض لكافة الصفحات'),
                      value: 'عمودی',
                      groupValue: state.pageOrientation,
                      onChanged: (value) {
                        cubit.changePageOrientation(value!);
                      },
                    ),
                  ],
                ),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    return CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 100,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 2),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: state.axix,
                      ),
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Card(
                        color: Color(state.selectedBackgroundColor),
                        child: SizedBox(
                          width: EsaySize.width(context),
                          child: Center(
                              child: Text(
                            'بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(state.selectedBackgroundColor) ==
                                        const Color(0xFF242323)
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  SliderThemeData themeSlider() {
    return const SliderThemeData(
        valueIndicatorTextStyle: TextStyle(color: Colors.white, fontSize: 12),
        trackHeight: 2,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5));
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildColorOption(
      BuildContext context, Color color, SettingsState state) {
    final cubit = context.read<SettingsCubit>();
    return GestureDetector(
      onTap: () {
        if (state.isLightMode) {
          cubit.changeBackgroundColor(color);
        } else {
          CustomSnackBar.show(context,
              message: 'لتغيير اللون، قم بتغيير وضع التطبيق إلى النهار أولاً.');
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: state.selectedBackgroundColor == color.value
                ? Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundOption(
      BuildContext context, Color color, SettingsState state) {
    final cubit = context.read<SettingsCubit>();
    return GestureDetector(
      onTap: () => cubit.changePageColor(color),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: color, border: Border.all(color: Colors.black)),
        child: state.selectedPageColor == color.value
            ? Icon(Icons.check,
                color:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor)
            : null,
      ),
    );
  }
}
