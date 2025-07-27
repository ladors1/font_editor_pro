// lib/screens/editor_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_editor_pro/utils/fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController _textController = TextEditingController(text: "متن شما...");

  // متغیرهای استایل
  BoxDecoration _backgroundDecoration = const BoxDecoration(color: Colors.black);
  double _fontSize = 32.0;
  Color _textColor = Colors.white;
  String _fontFamily = 'Vazirmatn'; // فونت پیش فرض از لیست شما
  TextAlign _textAlign = TextAlign.center;
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  List<Shadow> _textShadows = [];

  // تابع برای ذخیره تصویر
  Future<void> _saveImage() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final Uint8List? image = await _screenshotController.capture(
        pixelRatio: 2.0, // افزایش کیفیت خروجی
      );
      if (image != null && mounted) {
        final result = await ImageGallerySaver.saveImage(image, name: "font_design_${DateTime.now().millisecondsSinceEpoch}");
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تصویر با موفقیت در گالری ذخیره شد!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('خطا در ذخیره تصویر.')),
          );
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برای ذخیره تصویر به دسترسی نیاز است.')),
      );
    }
  }

  // تابع برای نمایش انتخاب‌گر رنگ
  void _showColorPicker({required bool forText}) {
    Color pickerColor = forText ? _textColor : (_backgroundDecoration.color ?? Colors.black);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(forText ? 'انتخاب رنگ متن' : 'انتخاب رنگ پس‌زمینه'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('تایید'),
            onPressed: () {
              setState(() {
                if (forText) {
                  _textColor = pickerColor;
                } else {
                  _backgroundDecoration = BoxDecoration(color: pickerColor);
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // تعداد تب‌های ابزار
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ویرایشگر'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save, size: 28),
              onPressed: _saveImage,
              tooltip: 'ذخیره تصویر',
            ),
          ],
        ),
        body: Column(
          children: [
            // بوم طراحی
            Expanded(
              child: Screenshot(
                controller: _screenshotController,
                child: Container(
                  decoration: _backgroundDecoration,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        textAlign: _textAlign,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'متن خود را اینجا بنویسید...',
                          hintStyle: TextStyle(color: Colors.white54)
                        ),
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: _fontSize,
                          color: _textColor,
                          fontWeight: _fontWeight,
                          fontStyle: _fontStyle,
                          shadows: _textShadows,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // پنل ابزارها
            Container(
              color: const Color(0xFF16213e),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(icon: Icon(Icons.font_download), text: "فونت"),
                      Tab(icon: Icon(Icons.format_size), text: "استایل"),
                      Tab(icon: Icon(Icons.color_lens), text: "رنگ"),
                      Tab(icon: Icon(Icons.wallpaper), text: "پس‌زمینه"),
                    ],
                  ),
                  SizedBox(
                    height: 160, // ارتفاع پنل ابزارها
                    child: TabBarView(
                      children: [
                        _buildFontTab(),
                        _buildStyleTab(),
                        _buildColorTab(),
                        _buildBackgroundTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تب انتخاب فونت
  Widget _buildFontTab() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: AppFonts.fontFamilies.length,
      itemBuilder: (context, index) {
        final font = AppFonts.fontFamilies[index];
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Tooltip(
              message: font,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: _fontFamily == font ? Colors.deepPurpleAccent : Colors.white24,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text("متن", style: TextStyle(fontFamily: font, fontSize: 22)),
                onPressed: () => setState(() => _fontFamily = font),
              ),
            ),
          ),
        );
      },
    );
  }

  // تب استایل متن
  Widget _buildStyleTab() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text("اندازه", style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 150.0,
                    divisions: 140,
                    label: _fontSize.round().toString(),
                    onChanged: (newSize) => setState(() => _fontSize = newSize),
                    activeColor: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleButtons(
                  isSelected: [_textAlign == TextAlign.left, _textAlign == TextAlign.center, _textAlign == TextAlign.right],
                  onPressed: (index) => setState(() => _textAlign = [TextAlign.left, TextAlign.center, TextAlign.right][index]),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.black,
                  color: Colors.white,
                  fillColor: Colors.deepPurpleAccent,
                  children: const [Icon(Icons.format_align_left), Icon(Icons.format_align_center), Icon(Icons.format_align_right)],
                ),
                ToggleButtons(
                  isSelected: [_fontWeight == FontWeight.bold, _fontStyle == FontStyle.italic],
                  onPressed: (index) {
                    setState(() {
                      if (index == 0) _fontWeight = _fontWeight == FontWeight.bold ? FontWeight.normal : FontWeight.bold;
                      if (index == 1) _fontStyle = _fontStyle == FontStyle.italic ? FontStyle.normal : FontStyle.italic;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.black,
                  color: Colors.white,
                  fillColor: Colors.deepPurpleAccent,
                  children: const [Icon(Icons.format_bold), Icon(Icons.format_italic)],
                ),
                Row(
                  children: [
                    const Text("سایه", style: TextStyle(color: Colors.white)),
                    Switch(
                      value: _textShadows.isNotEmpty,
                      onChanged: (value) => setState(() => _textShadows = value
                          ? [const Shadow(blurRadius: 5.0, color: Colors.black54, offset: Offset(2, 2))]
                          : []),
                      activeColor: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      );
  }
  
  // تب رنگ
  Widget _buildColorTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.format_color_text),
          label: const Text("رنگ متن"),
          onPressed: () => _showColorPicker(forText: true),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.format_color_fill),
          label: const Text("رنگ پس‌زمینه"),
          onPressed: () => _showColorPicker(forText: false),
        ),
      ],
    );
  }

  // تب پس‌زمینه
  Widget _buildBackgroundTab() {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        // دکمه شفاف
        _buildBackgroundOption(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: const Center(child: Icon(Icons.do_not_disturb_on, color: Colors.white, size: 32)),
        ),
        // دکمه گرادینت
        _buildBackgroundOption(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
          ),
        ),
        // تصاویر پس‌زمینه
        ...AppFonts.backgroundImages.map((imageName) {
          final imagePath = 'assets/backgrounds/$imageName';
          return _buildBackgroundOption(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBackgroundOption({required BoxDecoration decoration, Widget? child}) {
    return GestureDetector(
      onTap: () => setState(() => _backgroundDecoration = decoration),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: decoration.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white30, width: 2),
        ),
        child: child,
      ),
    );
  }
}