import 'package:intl/intl.dart';

/// Memakai locale id_ID: `initializeDateFormatting('id_ID')` dipanggil di main().
class DateFormatter {
  DateFormatter._();

  /// Contoh: 18 Nov 2026
  static String formatDate(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    return DateFormat('d MMM yyyy', 'id_ID').format(date.toLocal());
  }

  /// Contoh: Rabu, 18 November 2026, 07.30
  static String formatLong(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    return DateFormat('EEEE, d MMMM yyyy, HH.mm', 'id_ID').format(date.toLocal());
  }
}
