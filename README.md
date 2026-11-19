# Berita Teknologi (News App) — Flutter + GNews

Aplikasi berita teknologi Indonesia dengan tampilan gaya iOS (Cupertino).
Data dari GNews endpoint `/search`, memakai `dio` dan `FutureBuilder`
(acuan: Modul Topic 11).

## Fitur

- Daftar berita (`FutureBuilder`) dengan empat state: loading, error, kosong, data.
- Pilihan topik (kata kunci) berbentuk pil yang bisa digeser: Terbaru, AI, Gadget, Startup, Keamanan Siber, Game, Internet & 5G.
- Cache `Map<String, Future<List<ArticleModel>>>` di `State`: memilih topik yang sama lagi tidak mengirim request baru.
- Pull-to-refresh ala iOS (`CupertinoSliverRefreshControl`): memuat data terbaru dan memperbarui cache topik yang dibuka.
- Pencarian: ikon cari di navigation bar → dialog → `searchNews()` → halaman hasil (juga `FutureBuilder`).
- Halaman detail berita.
- `ApiException` dengan 10 pesan error berbeda (lihat tabel skenario) + tombol **Coba Lagi** yang mengirim request baru.

## Struktur

```
config/env.example.json        template 
config/env.json                rahasia, DIABAIKAN git
lib/config/                    env.dart (baca URL & key), news_topics.dart
lib/models/                    article_model, news_response_model
lib/services/                  news_api_service, api_exception, error_messages
lib/views/                     home_view, search_results_view, detail_view
lib/widgets/                   article_card, news_image, error_view, empty_view,
                               loading_view, topic_chips, search_dialog,
                               news_snapshot_sliver, pressable_opacity
lib/routes/                    app_routes, app_pages
lib/utils/                     app_colors, date_formatter
test/widget_test.dart          unit test ApiException & ArticleModel
docs/screenshots/              screenshot skenario error 
```

## Screenshot

![Screenshot 1](/Users/muhammadmuftahillah/Kuliah/Semester%205/Pemograman%20Mobile/Pak%20Rafi'e/news_app/docs/screenshots/error-api-key-salah.png) --> Api Key Salah
![Screenshot 2](/Users/muhammadmuftahillah/Kuliah/Semester%205/Pemograman%20Mobile/Pak%20Rafi'e/news_app/docs/screenshots/error-tanpa-internet.png) --> Tanpa Internet
![Screenshot 3](/Users/muhammadmuftahillah/Kuliah/Semester%205/Pemograman%20Mobile/Pak%20Rafi'e/news_app/docs/screenshots/api-key-salah.png) --> Api Key Salah (Setelah di reset)
![Screenshot 4](/Users/muhammadmuftahillah/Kuliah/Semester%205/Pemograman%20Mobile/Pak%20Rafi'e/news_app/docs/screenshots/tanpa-internet.png) --> Tanpa Internet (Setelah di reset)
