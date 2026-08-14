import 'package:flutter/material.dart';

class ReportOption {
  final String title;
  final String assetImage;
  final VoidCallback onTap;
  final bool newMessages;
  const ReportOption({
    Key? key,
    required this.title,
    required this.assetImage,
    required this.onTap,
    this.newMessages = false,
  });
}
