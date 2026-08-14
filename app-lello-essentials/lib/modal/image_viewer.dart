import 'dart:io';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
// Import with an alias to avoid conflict, if you need to use image processing functions later
import 'package:flutter/src/widgets/image.dart' as img_lib;

class IMGScreen extends StatefulWidget {
  final String title;
  final File imageFile;

  IMGScreen({
    required this.imageFile,
    this.title = '',
  });

  @override
  State<IMGScreen> createState() => _IMGScreenState();
}

class _IMGScreenState extends State<IMGScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: LelloTheme.palleteOf(theme).customColor(),
        ),
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: LelloTheme.palleteOf(theme).customColor(),
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: img_lib.Image.file(widget.imageFile)),
      ),
    );
  }
}
