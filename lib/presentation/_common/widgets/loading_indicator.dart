import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final int? progress;
  final Color? color;
  final double size;
  final bool withBackground;
  const LoadingIndicator({
    super.key,
    this.progress,
    this.size = 50,
    this.withBackground = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
