import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildColorOption(context, Colors.blue, state),
                    _buildColorOption(context, Colors.brown, state),
                    _buildColorOption(context, Colors.grey, state),
                    _buildColorOption(context, Colors.green, state),
                    _buildColorOption(context, Colors.teal, state),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('حجم الخط:'),
                Row(
                  children: [
                    const Icon(Icons.text_fields),
                    Expanded(
                      child: Slider(
                        value: state.fontSize,
                        min: 10,
                        max: 30,
                        divisions: 20,
                        label: state.fontSize.toString(),
                        onChanged: cubit.changeFontSize,
                      ),
                    ),
                    Text(state.fontSize.toStringAsFixed(0)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('تباعد الأسطر:'),
                Row(
                  children: [
                    const Icon(Icons.format_line_spacing),
                    Expanded(
                      child: Slider(
                        value: state.lineSpacing,
                        min: 1,
                        max: 3,
                        divisions: 20,
                        label: state.lineSpacing.toStringAsFixed(1),
                        onChanged: cubit.changeLineSpacing,
                      ),
                    ),
                    Text(state.lineSpacing.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 16),
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
                _buildSectionTitle('لون الخلفية:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBackgroundOption(context, Colors.white, state),
                    _buildBackgroundOption(context, Colors.grey[200]!, state),
                    _buildBackgroundOption(context, Colors.black, state),
                  ],
                ),
                const SizedBox(height: 16),
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
                        color: Colors.white,
                        child: SizedBox(
                          width: EsaySize.width(context),
                          child: const Center(
                              child: Text(
                            'بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black),
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
      onTap: () => cubit.changeBackgroundColor(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: state.selectedBackgroundColor == color
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
      onTap: () => cubit.changeBackgroundColor(color),
      child: Container(
        width: 50,
        height: 50,
        color: color,
        child: state.selectedBackgroundColor == color
            ? const Icon(Icons.check, color: Colors.black)
            : null,
      ),
    );
  }
}
