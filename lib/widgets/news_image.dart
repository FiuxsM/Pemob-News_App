import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_colors.dart';

/// Gambar berita dengan placeholder saat memuat dan tampilan pengganti
/// yang rapi bila gagal. Di web memakai Image.network (aman dari CORS),
/// di perangkat memakai CachedNetworkImage.
class NewsImage extends StatelessWidget {
  final String url;
  final double aspectRatio;

  const NewsImage({super.key, required this.url, this.aspectRatio = 16 / 9});

  @override
  Widget build(BuildContext context) {
    final loading = _Panel(
      child: const CupertinoActivityIndicator(),
    );
    final failed = _Panel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.photo, size: 30, color: AppColors.tertiaryLabel(context)),
          const SizedBox(height: 6),
          Text(
            'Gambar tidak tersedia',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryLabel(context)),
          ),
        ],
      ),
    );

    final Widget image;
    if (kIsWeb) {
      image = Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.cover,
        // Bila gambar ditolak CORS, Flutter memakai elemen <img> HTML
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : loading,
        errorBuilder: (context, error, stack) => failed,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => loading,
        errorWidget: (context, url, error) => failed,
      );
    }
    return AspectRatio(aspectRatio: aspectRatio, child: image);
  }
}

class _Panel extends StatelessWidget {
  final Widget child;
  const _Panel({required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.fill(context),
      child: SizedBox.expand(child: Center(child: child)),
    );
  }
}
