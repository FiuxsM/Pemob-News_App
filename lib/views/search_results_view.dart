import 'package:flutter/cupertino.dart';

import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/news_snapshot_sliver.dart';

/// Halaman hasil pencarian: memanggil searchNews() dan menampilkannya
/// dengan FutureBuilder (empat state yang sama dengan halaman utama).
class SearchResultsView extends StatefulWidget {
  final String keyword;

  const SearchResultsView({super.key, required this.keyword});

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  final NewsApiService _service = NewsApiService.shared;

  /// Disimpan di State, dibuat sekali di initState().
  late Future<List<ArticleModel>> _futureResults;

  @override
  void initState() {
    super.initState();
    _futureResults = _service.searchNews(widget.keyword);
  }

  void _cobaLagi() {
    setState(() {
      _futureResults = _service.searchNews(widget.keyword);
    });
  }

  Future<void> _onRefresh() async {
    final future = _service.searchNews(widget.keyword);
    try {
      await future;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder.
    }
    if (!mounted) return;
    setState(() {
      _futureResults = future;
    });
  }

  void _bukaDetail(ArticleModel article) {
    Navigator.of(context).pushNamed(AppRoutes.detail, arguments: article);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Hasil Pencarian'),
              previousPageTitle: 'Beranda',
            ),
            CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  'Kata kunci: “${widget.keyword}”',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.secondaryLabel(context),
                  ),
                ),
              ),
            ),
            FutureBuilder<List<ArticleModel>>(
              future: _futureResults,
              builder: (context, snapshot) => NewsSnapshotSliver(
                snapshot: snapshot,
                onRetry: _cobaLagi,
                onOpen: _bukaDetail,
                emptyTitle: 'Tidak ada hasil',
                emptyMessage:
                    'Berita dengan kata kunci ini tidak ditemukan. Coba kata kunci lain.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
