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
config/env.example.json        template (di-commit)
config/env.json                rahasia, DIABAIKAN git (Anda buat sendiri)
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

## Menjalankan

Folder platform (`android/`, `ios/`, `web/`) belum ada karena project ini dibuat tanpa Flutter SDK. Buat sekali di folder project:

```bash
cd news_app
git init   # lewati jika sudah ada repo
flutter create --platforms=android,ios,web --project-name news_app .
flutter pub get
```

`flutter create .` hanya menambah file yang belum ada; `lib/`, `pubspec.yaml`, dan `test/widget_test.dart` tetap milik project ini. Cek dengan `git status` bila ragu.

Android release: tambahkan di `android/app/src/main/AndroidManifest.xml`, di atas `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Mengatur API key (lokal, tidak masuk Git)

1. Daftar di <https://gnews.io>, **verifikasi email** (tanpa verifikasi request ditolak 403), salin API key dari dashboard.
2. Salin template lalu isi key milik Anda:
   ```bash
   cp config/env.example.json config/env.json
   ```
   ```json
   {
     "GNEWS_BASE_URL": "https://gnews.io/api/v4",
     "GNEWS_API_KEY": "<tempel key Anda di sini>"
   }
   ```
3. Jalankan:
   ```bash
   flutter run --dart-define-from-file=config/env.json            # iOS/Android
   flutter run -d chrome --dart-define-from-file=config/env.json  # browser
   ```
   Di VS Code, `.vscode/launch.json` sudah menyertakan argumen yang sama.

`config/env.json` ada di `.gitignore`; hanya `config/env.example.json` (tanpa nilai rahasia) yang di-commit. Key tidak ada di source code, dan log debug menyamarkannya menjadi `***`. Catatan: nilai `--dart-define` tetap ikut terkompilasi ke binary, jadi untuk rilis publik gunakan proxy seperti di bagian 10 modul.

Paket gratis GNews: 100 request/hari, maks 1 request/detik, artikel tertunda ±12 jam.

## Skenario error (semua berpesan berbeda)

| Skenario | Cara memicu | Pesan di layar |
|---|---|---|
| Konfigurasi kosong | jalankan **tanpa** `--dart-define-from-file` | Konfigurasi belum diisi. Jalankan dengan --dart-define-from-file=config/env.json |
| API key salah (401) | ubah `GNEWS_API_KEY` menjadi 32 karakter `0` | API key salah atau tidak terdaftar. |
| Format key salah (400) | `GNEWS_API_KEY` = `salah123` | Permintaan tidak valid. + pesan server |
| Terlalu cepat (429) | ganti topik berkali-kali dengan cepat | Terlalu cepat. Paket gratis hanya 1 request per detik. |
| Kuota / email belum verifikasi (403) | akun belum verifikasi atau kuota habis | Kuota harian habis atau email akun belum diverifikasi. |
| Tidak ada internet | mode pesawat (di web: DevTools → Network → Offline) | Tidak ada koneksi internet. Periksa jaringan Anda. |
| Server lambat | ubah sementara `receiveTimeout` di `news_api_service.dart` menjadi `Duration(milliseconds: 1)` | Koneksi lambat. Server tidak merespons tepat waktu. |
| JSON tidak cocok | ubah sementara `as int?` di `news_response_model.dart` menjadi `as String?` | Struktur data dari server berbeda dari model. |

Setelah memicu, kembalikan kode/konfigurasi ke semula.

## Dua screenshot error yang diminta

Screenshot **belum** dibuat di repo ini karena lingkungan penyusun tidak memiliki Flutter SDK/emulator, dan screenshot palsu tidak boleh dibuat. Cara membuatnya (±5 menit):

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

Sebelum push, pastikan `git status` tidak menampilkan `config/env.json`.

## Asumsi

- Tidak ada project awal, jadi project dibuat dari nol mengikuti struktur modul.
- Navigasi memakai `Navigator` + `CupertinoPageRoute` (bukan GetX): swipe-back iOS bawaan, satu dependensi lebih sedikit.
- Ikon cari memakai `CupertinoButton` berisi ikon (setara `IconButton`; `IconButton` Material memerlukan ancestor `Material` yang tidak ada di `CupertinoApp`).
- Setiap topik dimuat dengan `/search`; kuerinya ada di `lib/config/news_topics.dart`.
- Future yang gagal tidak disimpan di cache agar topik itu dicoba ulang saat dipilih lagi.
- Detail berita menyalin tautan ke clipboard (tanpa paket `url_launcher`, tidak mengubah dependensi modul).
- Label bawaan sistem (menu salin/tempel) memakai bahasa Inggris karena `flutter_localizations` tidak ditambahkan.
