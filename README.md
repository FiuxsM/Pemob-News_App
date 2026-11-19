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
config/env.json                not commited
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
docs/screenshots/              screenshot skenario error (Anda isi, lihat di bawah)
```

1. **`docs/screenshots/error-api-key-salah.png`** — isi `GNEWS_API_KEY` dengan 32 karakter `0`, jalankan aplikasi. Layar menampilkan "API key salah atau tidak terdaftar." + tombol Coba Lagi. Ambil screenshot.
2. **`docs/screenshots/error-tanpa-internet.png`** — kembalikan key yang benar, nyalakan mode pesawat, lalu ketuk **Coba Lagi** atau pilih topik yang belum pernah dimuat. Layar menampilkan "Tidak ada koneksi internet. Periksa jaringan Anda." + Coba Lagi. Ambil screenshot.

Bukti tombol berfungsi: matikan mode pesawat, ketuk **Coba Lagi** — berita muncul. Simpan kedua file di `docs/screenshots/`, lalu `git add docs/screenshots && git commit`.

## Mengumpulkan lewat GitHub

Repo git lokal sudah disiapkan (lihat `git log`), tetapi belum diunggah. Jalankan sendiri:

```bash
# buat repo kosong bernama news_app di github.com (jangan centang README/.gitignore), lalu:
git remote add origin https://github.com/<username>/news_app.git
git branch -M main
git push -u origin main
```
