import 'package:flutter/cupertino.dart';

import '../utils/app_colors.dart';

/// Dialog pencarian ala iOS. Mengembalikan kata kunci (sudah di-trim) atau null.
class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showCupertinoDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const SearchDialog(),
    );
  }

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) {
      setState(() => _error = 'Kata kunci tidak boleh kosong.');
      return;
    }
    Navigator.of(context).pop(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Cari berita'),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            CupertinoTextField(
              controller: _controller,
              autofocus: true,
              maxLength: 100,
              placeholder: 'Contoh: kecerdasan buatan',
              textInputAction: TextInputAction.search,
              clearButtonMode: OverlayVisibilityMode.editing,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _kirim(),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(fontSize: 13, color: AppColors.destructive(context)),
                ),
              ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: _kirim,
          child: const Text('Cari'),
        ),
      ],
    );
  }
}
