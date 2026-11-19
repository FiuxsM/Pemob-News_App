/// Semua teks error di satu tempat supaya tidak disalin berulang-ulang.
class ErrorMessages {
  ErrorMessages._();

  // Terdeteksi aplikasi sebelum / tanpa respons server
  static const configMissing = 'Konfigurasi belum diisi. Jalankan dengan '
      '--dart-define-from-file=config/env.json';
  static const timeout = 'Koneksi lambat. Server tidak merespons tepat waktu.';
  static const noConnection = 'Tidak ada koneksi internet. Periksa jaringan Anda.';
  static const badCertificate = 'Sertifikat keamanan server tidak valid.';
  static const cancelled = 'Permintaan dibatalkan.';
  static const invalidFormat = 'Format data dari server tidak dikenali.';
  static const modelMismatch = 'Struktur data dari server berbeda dari model.';

  // Berdasarkan status HTTP dari GNews
  static const badRequest = 'Permintaan tidak valid.';
  static const apiKeyInvalid = 'API key salah atau tidak terdaftar.';
  static const quotaOrUnverified =
      'Kuota harian habis atau email akun belum diverifikasi.';
  static const notFound = 'Alamat endpoint tidak ditemukan.';
  static const tooManyRequests =
      'Terlalu cepat. Paket gratis hanya 1 request per detik.';

  static String serverError(int code) => 'Server GNews sedang bermasalah ($code).';
  static String unknownStatus(int? code) =>
      'Gagal memuat data (kode ${code ?? '-'}).';
  static String unexpected(String detail) =>
      'Terjadi kesalahan tak terduga: $detail';
}
