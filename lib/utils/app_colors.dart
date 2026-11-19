import 'package:flutter/cupertino.dart';

/// Warna semantik iOS. Otomatis mengikuti mode terang/gelap perangkat.
class AppColors {
  AppColors._();

  static Color background(BuildContext c) =>
      CupertinoColors.systemGroupedBackground.resolveFrom(c);
  static Color card(BuildContext c) =>
      CupertinoColors.secondarySystemGroupedBackground.resolveFrom(c);
  static Color label(BuildContext c) => CupertinoColors.label.resolveFrom(c);
  static Color secondaryLabel(BuildContext c) =>
      CupertinoColors.secondaryLabel.resolveFrom(c);
  static Color tertiaryLabel(BuildContext c) =>
      CupertinoColors.tertiaryLabel.resolveFrom(c);
  static Color separator(BuildContext c) => CupertinoColors.separator.resolveFrom(c);
  static Color fill(BuildContext c) => CupertinoColors.tertiarySystemFill.resolveFrom(c);
  static Color accent(BuildContext c) => CupertinoColors.systemBlue.resolveFrom(c);
  static Color destructive(BuildContext c) => CupertinoColors.systemRed.resolveFrom(c);
}
