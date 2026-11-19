import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Tanpa ini tanggal id_ID tampil sebagai teks ISO mentah.
  await initializeDateFormatting('id_ID');
  runApp(const NewsApp());
}

/// Di browser, drag mouse tidak menggulir list secara default, sehingga
/// pull-to-refresh tidak bisa ditarik. Izinkan mouse (hanya berpengaruh di web/desktop).
class _DragDenganMouse extends CupertinoScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {...super.dragDevices, PointerDeviceKind.mouse};
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Berita Teknologi',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(primaryColor: CupertinoColors.systemBlue),
      scrollBehavior: _DragDenganMouse(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppPages.onGenerateRoute,
    );
  }
}
