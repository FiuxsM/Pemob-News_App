import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/news_image.dart';

class DetailView extends StatelessWidget {
  final ArticleModel article;

  const DetailView({super.key, required this.article});

  Future<void> _salinTautan(BuildContext context) async {
    final url = article.url;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    await showCupertinoDialog<void>(
      context: context,
      builder:
          (dialogContext) => CupertinoAlertDialog(
            title: const Text('Tautan disalin'),
            content: const Text(
              'Tempel di browser untuk membaca artikel lengkap.',
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Oke'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = article.urlToImage;
    final description = article.description;
    final content = article.content;
    final date = DateFormatter.formatLong(article.publishedAt);
    final showContent =
        content != null && content.isNotEmpty && content != description;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detail Berita'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null && image.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: NewsImage(url: image),
                        ),
                      ),
                    if (article.author != null)
                      Text(
                        article.author!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent(context),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: AppColors.label(context),
                      ),
                    ),
                    if (date.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryLabel(context),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(height: 0.5, color: AppColors.separator(context)),
                    const SizedBox(height: 16),
                    if (description != null && description.isNotEmpty)
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: AppColors.label(context),
                        ),
                      ),
                    if (showContent) ...[
                      const SizedBox(height: 14),
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.45,
                          color: AppColors.label(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cuplikan artikel. Isi lengkap tersedia di situs sumber.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryLabel(context),
                        ),
                      ),
                    ],
                    if (article.url != null) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: () => _salinTautan(context),
                          child: const Text('Salin Tautan Artikel'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
