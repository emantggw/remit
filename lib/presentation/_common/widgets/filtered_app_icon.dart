import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:remit/presentation/_common/app_colors.dart';

class FilteredAppIcon extends StatelessWidget {
  final IconData icon;
  final double borderRadius;
  const FilteredAppIcon({
    super.key,
    required this.icon,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: CircleAvatar(
          backgroundColor: kcGrey.withValues(alpha: 0.8),
          child: Icon(icon, color: kcOnPrimary(context)),
        ),
      ),
    );
  }
}
