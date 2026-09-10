# AGENTS.md — KosanKu (Cari Kos SaaS)

## Dokumen Rujukan Wajib

Proyek ini punya dua dokumen *source of truth* yang **WAJIB dibaca sebelum mengerjakan task apa pun**, dan **WAJIB diikuti tanpa penyimpangan** kecuali diinstruksikan lain secara eksplisit oleh pengguna dalam sesi ini:

| Dokumen | Otoritas atas | Kapan wajib dibaca |
|---|---|---|
| `prd.md` | Requirement fungsional, alur pengguna, model bisnis, arsitektur, skema database, batasan teknis & keamanan | Sebelum implementasi fitur, endpoint, logic backend, atau perubahan alur apa pun |
| `DESIGN.md` | Warna (light & dark mode), tipografi, spacing, shape/rounded, elevation, komponen UI | Sebelum membuat atau mengubah UI/komponen apa pun |

Jika sebuah task menyentuh keduanya (mis. membuat halaman baru), baca **kedua file** dulu sebelum menulis kode. Jangan menebak nilai warna/spacing/copy — ambil dari dokumen ini.

Jika instruksi ad-hoc dari pengguna tampak bertentangan dengan `prd.md` atau `DESIGN.md`, **konfirmasi dulu ke pengguna** sebelum menyimpang; jangan diam-diam mengabaikan salah satu dokumen.

---

## Ringkasan Proyek

**KosanKu** — platform SaaS pencarian kos. **Pencari Kos** mencari & menghubungi Pemilik Kos secara gratis. **Pemilik Kos** berlangganan (Free/Berbayar) untuk mengelola listing. Interaksi lanjutan (tanya info kamar, ajukan booking, ajukan observasi) terpusat lewat **chat dalam aplikasi**; tombol **WhatsApp** di halaman Detail Kos jadi jalur kontak cepat alternatif (deep link `wa.me`, klien-only, tidak lewat backend).

Detail lengkap: lihat `prd.md` §1–§2.

## Peran & Model Bisnis
- **Dua peran**, ditentukan saat registrasi: **Pencari Kos** (gratis penuh) dan **Pemilik Kos** (tenant berlangganan).
- **Freemium 2 tingkat** untuk Pemilik Kos: **Free** (maks. 1 kos aktif, tanpa fitur promosi) vs **Berbayar** (listing tanpa batas + **Kos Unggulan/Featured**).
- Pembayaran wajib lewat **payment gateway** pihak ketiga (Midtrans/Xendit-style); sistem hanya menyimpan status & referensi transaksi, bukan data kartu.

Detail lengkap: `prd.md` §2.

## Fitur Inti (MVP)
Urutan prioritas mengikuti `prd.md` §3 — jangan menambah/menghilangkan scope tanpa konfirmasi:
1. Onboarding & Autentikasi (email+password, verifikasi email, reset password, JWT session, lengkapi profil)
2. Explore & Pencarian Kos (search, filter tipe/harga/fasilitas, card listing)
3. Detail Kos (galeri, spesifikasi, fasilitas, kontak: Chat + WhatsApp, peta)
4. Favorit
5. Chat & Interaksi (inbox per menu bottom-nav, quick action: Info Kamar / Ajukan Pesanan / Ajukan Observasi)
6. Kelola Listing Kos (CRUD kos, dibatasi paket aktif)
7. Langganan & Pembayaran (upgrade, checkout, webhook, riwayat invoice)
8. Kos Unggulan (Featured) — eksklusif paket Berbayar

## Arsitektur Kunci
- Alur inti chat (info kamar, pesanan, observasi) mengikuti sequence diagram di `prd.md` §5: Frontend → Backend → DB, notifikasi ke Pemilik Kos, lalu Terima/Tolak yang mengupdate status booking.
- **Chat = menu/tab tersendiri (inbox multi-thread)**, BUKAN bubble mengambang — satu pengguna bisa punya banyak thread dengan lawan bicara berbeda.
- Tombol "Chat di Aplikasi" di Detail Kos adalah shortcut yang langsung membuka/membuat `conversation` (`user_id`, `owner_id`, `kos_id`) — jangan arahkan ke pencarian inbox manual.
- Booking/observasi harus tercatat sebagai bagian dari `conversation` yang sama, dengan status `pending/accepted/rejected` yang terlacak, bukan record terpisah tanpa relasi ke thread.

## Skema Database
Entity utama: `users`, `plans`, `subscriptions`, `transactions`, `kos`, `rooms`, `facilities`, `kos_facilities`, `photos`, `favorites`, `conversations`, `messages`, `bookings`.

ERD lengkap (kolom, tipe, relasi) ada di `prd.md` §6 — **rujuk ke sana sebagai satu-satunya sumber skema**. Jangan mendefinisikan ulang skema secara berbeda di tempat lain; kalau perlu migrasi/perubahan skema, update `prd.md` dulu agar tidak drift.

## Batasan Teknis & Keamanan (Wajib)
Dari `prd.md` §7:
- Password **wajib** di-hash (bcrypt/argon2) — tidak pernah plain text.
- Sesi login pakai **JWT** dengan expiry + refresh token mechanism.
- Tautan verifikasi email & reset password: **expired dalam 30–60 menit**, hanya sekali pakai.
- Endpoint login **wajib rate-limited** (anti brute-force).
- Status langganan **wajib disinkronkan lewat webhook** dari payment gateway — jangan percaya status dari sisi klien saja.
- Chat mendukung **quick action / kartu pesan terstruktur** (bukan cuma teks bebas) untuk Info Kamar, Pesanan, Observasi — supaya status pengajuan tetap terlacak dalam satu thread.
- Tombol WhatsApp: format `wa.me/<nomor>` + pesan otomatis berisi nama kos, hanya aktif jika nomor valid ada di data kos, murni client-side (tanpa proses backend tambahan).

## Aturan UI & Styling (Wajib — ikuti `DESIGN.md`)
Semua keputusan visual **wajib** merujuk token & aturan di `DESIGN.md`, termasuk versi `colors-dark` untuk dark mode. Ringkasan cepat:
- **Warna:** `primary` (#1A1A1A) hanya untuk elemen interaktif utama (CTA, active state, filter aktif). `background` warm off-white (#F5F4F0), `surface` pure white — kontras keduanya menciptakan depth, **bukan** shadow.
- **Shape:** Full pill (`9999px`) wajib untuk button, filter tag, search bar, floating bottom nav. Rounded besar (`24–32px`) untuk property card & image container.
- **Elevation:** **Flat design** — depth dari kontras warna, bukan drop shadow tebal. Pengecualian: floating bottom nav pakai glassmorphism (`backdrop-filter: blur`).
- **Dark mode:** WAJIB pakai token `colors-dark`, canvas warm near-black (bukan pure black `#000000`), `primary` di-invert jadi terang, elevation pakai border tipis (bukan shadow gelap). Detail penuh: `DESIGN.md` bagian "Dark Mode".
- **Tipografi:** Plus Jakarta Sans (geometric sans-serif), hierarki tebal (600–700) untuk harga & nama kos, regular + muted gray untuk label sekunder.

> ⚠️ **Catatan konflik yang perlu diperhatikan:** `prd.md` §7.5 (referensi desain awal) menyebut card dengan *"bayangan lembut (soft shadow)"*, sementara `DESIGN.md` (dokumen desain final) secara eksplisit melarang drop shadow dan menetapkan flat design berbasis kontras warna. **`DESIGN.md` yang menang** untuk seluruh keputusan styling — jangan tambahkan shadow pada card meski PRD menyebutnya.

## Tech Stack
`prd.md` §7.1 sengaja tidak mengunci teknologi tertentu, tapi berikut yang sudah **ditetapkan dan wajib dipakai** untuk sisi mobile app:

- **Framework:** Flutter
- **State management:** BLoC (`flutter_bloc`) — untuk business logic tiap fitur.
- **Routing:** `go_router`
- **HTTP client:** `Dio`
- Backend/DB/payment gateway SDK: belum ditetapkan, masih bebas sesuai `prd.md` §7.1.

Jangan ganti ke package state management/routing/http lain (mis. Provider, Riverpod, package `http` biasa) tanpa konfirmasi eksplisit ke pengguna — ini keputusan yang sudah ditetapkan, bukan default sementara.

### Fase Pengerjaan Saat Ini: UI-First
Fokus sekarang adalah membangun `presentation/` (pages + widgets) tiap fitur mengikuti `DESIGN.md`, boleh pakai dummy/mock data langsung di widget bila perlu, **tanpa** menyambungkan ke `bloc/`, `domain/`, atau `data/` dulu.

- `go_router` tetap disiapkan dari awal di `app/router/app_router.dart` karena navigasi antar halaman dibutuhkan sejak fase UI, bukan business logic.
- `Dio` baru benar-benar dipasang & dipakai saat fase business logic (data layer per fitur) dimulai — belum perlu di fase ini.
- Jika butuh state lokal sementara di layar UI (mis. toggle tab, expand/collapse), gunakan `StatefulWidget` biasa — jangan jadikan itu pengganti permanen BLoC.

### Struktur Folder (feature-first, disepakati)
```
lib/
├── main.dart
├── app/
│   ├── app.dart                  # MaterialApp/router config, ThemeData dari core/theme
│   └── router/
│       └── app_router.dart       # go_router — konfigurasi seluruh rute
│
├── core/                         # shared, lintas fitur
│   ├── theme/                    # <- mapping langsung dari DESIGN.md
│   │   ├── app_colors.dart       #    colors + colors-dark
│   │   ├── app_typography.dart   #    h1, h2, body-md, label-sm
│   │   ├── app_spacing.dart      #    xs..3xl
│   │   └── app_radius.dart       #    rounded sm..full
│   ├── widgets/                  # reusable UI: pill button, card, chip, bottom nav
│   ├── network/                  # (kosong) slot Dio client/interceptor — diisi saat fase business logic
│   ├── constants/
│   ├── utils/
│   └── di/                       # (kosong) slot service locator/DI
│
├── features/
│   ├── onboarding/
│   │   └── presentation/{pages,widgets}/
│   ├── auth/                     # login, register, verifikasi email, reset password
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/                 # (kosong)
│   │   ├── domain/               # (kosong)
│   │   └── data/                 # (kosong)
│   ├── explore/                  # search, filter, termasuk sorting/badge Kos Unggulan (Featured)
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/  domain/  data/ # (kosong)
│   ├── kos_detail/
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/  domain/  data/ # (kosong)
│   ├── favorites/
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/  domain/  data/ # (kosong)
│   ├── chat/                     # inbox + thread + quick action
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/  domain/  data/ # (kosong)
│   ├── listing_management/       # kelola kos (Pemilik Kos)
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/  domain/  data/ # (kosong)
│   ├── subscription/             # langganan & pembayaran
│   │   ├── presentation/{pages,widgets}/
│   │   ├── bloc/  domain/  data/ # (kosong)
│   └── profile/
│       ├── presentation/{pages,widgets}/
│       ├── bloc/  domain/  data/ # (kosong)
│
└── shared_bloc/                  # (kosong) slot state lintas fitur, mis. AuthBloc/SessionCubit global
```

Catatan: `Kos Unggulan (Featured)` (`prd.md` §3.8) **tidak** punya folder fitur sendiri — masuk ke `features/explore/` karena sifatnya cuma sorting/badge di hasil pencarian.

### Dependencies (pubspec.yaml) — wajib ada
```yaml
dependencies:
  flutter_bloc: ^<versi terbaru saat setup>
  go_router: ^<versi terbaru saat setup>
  dio: ^<versi terbaru saat setup>
```

### Command Build
Belum final — isi command aktual (`flutter pub get`, `flutter run`, `flutter test`, `flutter analyze`, `flutter build apk/ios`) setelah project di-scaffold pertama kali dengan `flutter create`.

## Verification Requirements (sebelum menandai task selesai)
- Fitur baru dicek ulang terhadap `prd.md` §3 (Core Features) dan §4 (User Flow) — pastikan tidak menyimpang dari alur yang didefinisikan.
- Perubahan UI dicek ulang terhadap `DESIGN.md` — termasuk memastikan komponen bekerja di **light & dark mode**.
- Setiap fitur yang menyentuh pembayaran/langganan: pastikan status akhir disinkron lewat webhook, bukan asumsi optimistik di klien.
- Setiap fitur chat/booking: pastikan tetap tercatat dalam `conversation` thread yang sama, bukan tabel/alur terpisah.
- Fitur baru yang dibuat di fase UI-first tetap punya folder `bloc/`, `domain/`, `data/` (boleh kosong) sesuai Struktur Folder — jangan lewati demi "cepat selesai".

## Rules to Never Break
- JANGAN mengubah skema database tanpa update `prd.md` §6 lebih dulu.
- JANGAN membuat bubble chat mengambang — chat wajib berupa tab/menu inbox multi-thread.
- JANGAN menyimpan data kartu/pembayaran sensitif langsung di sistem.
- JANGAN memakai sharp corner (0px radius) pada container besar, card, atau button utama.
- JANGAN menambahkan heavy/dark drop shadow pada card di kondisi apa pun (light maupun dark mode) — lihat catatan konflik di atas.
- JANGAN biarkan `primary` tetap gelap saat dark mode aktif — wajib di-invert sesuai `colors-dark`.
- JANGAN taruh state/business logic permanen langsung di widget `presentation/` sebagai pengganti BLoC — state lokal UI (`StatefulWidget`) hanya untuk kebutuhan sementara di fase UI-first.
- JANGAN mengganti `flutter_bloc`, `go_router`, atau `dio` dengan package lain tanpa konfirmasi eksplisit ke pengguna.
