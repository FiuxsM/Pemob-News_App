import 'package:flutter/cupertino.dart';

import '../config/news_topics.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/news_snapshot_sliver.dart';
import '../widgets/search_dialog.dart';
import '../widgets/topic_chips.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService.shared;

  /// Future hasil tiap topik. Memilih topik yang sama lagi memakai Future ini,
  /// jadi tidak ada request baru (hemat kuota 100 request/hari).
  final Map<String, Future<List<ArticleModel>>> _cache = {};

  NewsTopic _selected = NewsTopics.all.first;

  /// Future yang sedang tampil. Disimpan di State, BUKAN dibuat di build().
  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _ambil(_selected);
  }

  /// Mengambil Future dari cache; bila belum ada (atau [paksaBaru]) kirim request
  /// dan simpan hasilnya. Future yang gagal dibuang dari cache agar memilih topik
  /// itu lagi mencoba ulang, bukan menampilkan error lama.
  Future<List<ArticleModel>> _ambil(NewsTopic topic, {bool paksaBaru = false}) {
    final tersimpan = _cache[topic.id];
    if (!paksaBaru && tersimpan != null) return tersimpan;

    final future = _service.searchNews(topic.query);
    _cache[topic.id] = future;
    future.then<void>((_) {}, onError: (Object _) {
      if (identical(_cache[topic.id], future)) _cache.remove(topic.id);
    });
    return future;
  }

  void _gantiTopik(NewsTopic topic) {
    if (topic.id == _selected.id) return;
    setState(() {
      _selected = topic;
      _futureNews = _ambil(topic);
    });
  }

  /// Tombol "Coba Lagi": request baru, cache topik ini diperbarui.
  void _cobaLagi() {
    setState(() {
      _futureNews = _ambil(_selected, paksaBaru: true);
    });
  }

  /// Pull-to-refresh iOS: spinner tetap berputar sampai request selesai,
  /// lalu daftar diganti dengan data terbaru dan cache topik ini ikut diperbarui.
  Future<void> _onRefresh() async {
    final topic = _selected;
    final future = _ambil(topic, paksaBaru: true);
    try {
      await future;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder.
    }
    if (!mounted || topic.id != _selected.id) return;
    setState(() {
      _futureNews = future;
    });
  }

  Future<void> _bukaPencarian() async {
    final keyword = await SearchDialog.show(context);
    if (keyword == null || !mounted) return;
    Navigator.of(context).pushNamed(AppRoutes.search, arguments: keyword);
  }

  void _bukaDetail(ArticleModel article) {
    Navigator.of(context).pushNamed(AppRoutes.detail, arguments: article);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: SafeArea(
        top: false, // sisi atas ditangani navigation bar
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Berita Teknologi'),
              trailing: Semantics(
                label: 'Cari berita',
                button: true,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _bukaPencarian,
                  child: const Icon(CupertinoIcons.search),
                ),
              ),
            ),
            CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            SliverToBoxAdapter(
              child: TopicChips(
                topics: NewsTopics.all,
                selectedId: _selected.id,
                onSelected: _gantiTopik,
              ),
            ),
            FutureBuilder<List<ArticleModel>>(
              future: _futureNews,
              builder: (context, snapshot) => NewsSnapshotSliver(
                snapshot: snapshot,
                onRetry: _cobaLagi,
                onOpen: _bukaDetail,
                emptyTitle: 'Belum ada berita',
                emptyMessage:
                    'Tidak ada berita untuk topik ini. Tarik ke bawah untuk memuat ulang atau pilih topik lain.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
