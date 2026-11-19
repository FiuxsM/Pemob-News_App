import 'package:flutter/cupertino.dart';

import '../models/article_model.dart';
import 'article_card.dart';
import 'empty_view.dart';
import 'error_view.dart';
import 'loading_view.dart';

/// Isi FutureBuilder untuk halaman utama dan hasil pencarian.
/// Urutan pemeriksaan (sesuai modul): menunggu -> error -> kosong -> data.
/// Connection state diperiksa lebih dulu agar data/error lama tidak tampil
/// saat Future diganti (coba lagi, ganti topik).
class NewsSnapshotSliver extends StatelessWidget {
  final AsyncSnapshot<List<ArticleModel>> snapshot;
  final VoidCallback onRetry;
  final ValueChanged<ArticleModel> onOpen;
  final String emptyTitle;
  final String emptyMessage;

  const NewsSnapshotSliver({
    super.key,
    required this.snapshot,
    required this.onRetry,
    required this.onOpen,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    // 1) Loading
    if (snapshot.connectionState != ConnectionState.done) {
      return const SliverFillRemaining(hasScrollBody: false, child: LoadingView());
    }
    // 2) Error (selalu ApiException)
    if (snapshot.hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(message: snapshot.error.toString(), onRetry: onRetry),
      );
    }
    // 3) Kosong
    final articles = snapshot.data ?? const <ArticleModel>[];
    if (articles.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyView(title: emptyTitle, message: emptyMessage),
      );
    }
    // 4) Data
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 16 + bottomInset),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final article = articles[index];
            return ArticleCard(article: article, onTap: () => onOpen(article));
          },
          childCount: articles.length,
        ),
      ),
    );
  }
}
