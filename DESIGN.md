---
name: Nestora Property App
description: Premium, minimalist real estate mobile application focusing on high-contrast typography and pillowy shapes.
colors:
  primary: "#1A1A1A"
  secondary: "#FFFFFF"
  tertiary: "#F3F4F6"
  background: "#F5F4F0"
  surface: "#FFFFFF"
  text-primary: "#1A1A1A"
  text-secondary: "#6B7280"
  border: "#E5E7EB"
  success: "#10B981"
  warning: "#F59E0B"
  error: "#EF4444"
colors-dark:
  primary: "#F5F4F0"
  secondary: "#1A1A1A"
  tertiary: "#211F1C"
  background: "#141311"
  surface: "#1F1D1A"
  text-primary: "#F5F4F0"
  text-secondary: "#9C9890"
  border: "#302D29"
  success: "#34D399"
  warning: "#FBBF24"
  error: "#F87171"
typography:
  h1:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "2.5rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.02em"
  h2:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "1.5rem"
    fontWeight: 600
    lineHeight: 1.3
  body-md:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
    lineHeight: 1.5
  label-sm:
    fontFamily: "Plus Jakarta Sans, sans-serif"
    fontSize: "0.75rem"
    fontWeight: 500
rounded:
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  3xl: 64px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.surface}"
    rounded: "{rounded.full}"
    padding: "16px 32px"
  button-primary-hover:
    backgroundColor: "#000000"
  card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    padding: "{spacing.md}"
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.full}"
    padding: "14px 20px"
---

## Overview
Desain ini mengusung tone premium, elegan, dan *approachable* untuk aplikasi pencarian properti (Prop-tech). Tampilan sangat bersih dengan mengandalkan foto properti berkualitas tinggi, ditopang oleh *generous whitespace* dan kontras warna hitam-putih yang tegas untuk mengarahkan fokus pengguna secara natural.

## Colors
- **Primary (#1A1A1A):** Digunakan HANYA untuk elemen interaktif utama (Primary CTA button "Contact Now", active state pada bottom nav, dan filter pill yang sedang aktif).
- **Background (#F5F4F0):** Warna *warm off-white* yang menenangkan, digunakan sebagai canvas utama agar elemen `surface` berwarna pure white bisa *stand out* tanpa perlu shadow tebal.
- **Surface (#FFFFFF):** Digunakan pada *property cards*, *search bar*, dan *amenity chips* untuk menciptakan separasi visual yang bersih.

## Typography
Menggunakan *geometric sans-serif* modern (seperti Plus Jakarta Sans atau Poppins) yang memberikan kesan rapi dan terpercaya. Terdapat hierarki yang sangat kontras: ukuran besar dan *font-weight* tebal (600-700) digunakan untuk menarik perhatian ke Harga dan Nama Properti, sementara label sekunder (lokasi, spesifikasi) menggunakan *weight* regular dengan warna *muted gray*. Angka menggunakan format *tabular figures* untuk kemudahan membaca data spesifikasi.

## Spacing & Layout
Menggunakan **8px grid system** dengan pendekatan *mobile-first*. *Whitespace* sangat dominan (bersifat *generous/breathing*). Jarak antar *section* cukup besar (24px - 32px) untuk memberikan ruang bernapas pada foto arsitektur yang padat visual. Layout untuk spesifikasi menggunakan grid modular / *bento-style* 4-kolom.

## Shapes
Filosofi *shape* sangat condong ke arah **pillowy & soft**.
- **Full Pill (9999px):** Wajib digunakan untuk semua *buttons*, *filter tags*, *search bar*, dan *floating bottom navigation*.
- **Pillowy/Rounded Besar (24px - 32px):** Digunakan untuk semua *property cards* utama dan *image containers*.
- **Rounded Medium (16px):** Digunakan untuk *chips* spesifikasi di dalam halaman detail properti.

## Elevation & Depth
Mayoritas menggunakan pendekatan **Flat Design**. Kedalaman ruang (*depth*) tidak bergantung pada *drop shadow*, melainkan didapat dari kontras warna antara `surface` (Pure White) di atas `background` (Warm Off-white). 
Pengecualian hanya pada *Floating Bottom Navigation* yang menggunakan sentuhan *Glassmorphism* (`backdrop-filter: blur`) dipadukan dengan transparansi halus untuk memisahkan navigasi dari konten yang di-*scroll* di bawahnya.

## Components
- **Floating Bottom Navigation:** Berbentuk *full pill*, mengambang di atas konten, dengan *outline icons*. State aktif ditandai dengan *circular background* berwarna Primary (hitam).
- **Filter Pills:** Tag horizontal *scrollable*. Default state berwarna putih, active state berwarna hitam dengan teks putih.
- **Property Cards:** Menonjolkan gambar besar dengan ujung melengkung ekstrem, *floating favorite button* berbentuk lingkaran kecil di kanan atas gambar.
- **Amenity Bento Chips:** Kotak-kotak kecil berwarna putih untuk menampilkan spesifikasi rumah (kamar tidur, kamar mandi, luas tanah) yang disusun berjajar menggunakan *flexbox* / *grid*.

## Rules to Never Break
- JANGAN PERNAH menggunakan *sharp corners* (0px radius) untuk kontainer besar, *card*, atau *button* utama; semua sudut harus melengkung (*rounded* / *pill*).
- JANGAN PERNAH menambahkan *heavy/dark drop shadow* pada *card*; pertahankan *flat aesthetic* dan gunakan warna *background* bawaan untuk separasi.
- SELALU pertahankan rasio kontras ekstrem (Hitam/Putih) untuk CTA button (Call-to-Action) agar aksi pengguna tetap fokus dan tidak membingungkan.

## Dark Mode

Dark mode BUKAN sekadar inversi warna mentah (`#000` menggantikan `#FFF`). Filosofi *warm, pillowy, high-contrast* dari light mode tetap dipertahankan, hanya *canvas*-nya yang berganti dari *warm off-white* menjadi *warm near-black* — bukan pure black (`#000000`), agar tetap terasa premium dan tidak "murah" seperti OLED-saver app pada umumnya.

Token warna dark mode didefinisikan di `colors-dark` (lihat frontmatter), dengan key yang identik agar mudah di-*swap* melalui `[data-theme="dark"]` atau `prefers-color-scheme: dark`.

### Pemetaan Warna
| Token | Light | Dark | Catatan |
|---|---|---|---|
| `background` | `#F5F4F0` (warm off-white) | `#141311` (warm near-black) | Canvas utama, tetap warm-toned agar konsisten dengan brand, bukan cool-gray/pure black |
| `surface` | `#FFFFFF` | `#1F1D1A` | Satu step lebih terang dari `background` agar card tetap terpisah tanpa shadow |
| `primary` | `#1A1A1A` | `#F5F4F0` | **Dibalik total** — CTA button di dark mode berubah dari hitam-di-atas-putih menjadi krem/putih-di-atas-gelap, demi menjaga aturan kontras ekstrem tetap hidup |
| `secondary` | `#FFFFFF` | `#1A1A1A` | Mengikuti inversi `primary`, dipakai sebagai warna teks di atas CTA |
| `text-primary` | `#1A1A1A` | `#F5F4F0` | Teks utama tetap kontras tinggi terhadap `background` |
| `text-secondary` | `#6B7280` (cool gray) | `#9C9890` (warm gray) | Tetap *muted*, tapi warm-toned agar tidak terasa "cold/clinical" di atas background gelap |
| `border` | `#E5E7EB` | `#302D29` | Dipakai sebagai pengganti shadow untuk separasi (lihat Elevation) |
| `success` / `warning` / `error` | saturasi standar | dicerahkan (`#34D399` / `#FBBF24` / `#F87171`) | Warna semantik perlu dinaikkan *lightness*-nya agar tetap accessible (kontras AA) di atas background gelap |

### Elevation & Depth
Di light mode, separasi didapat murni dari kontras `surface` (putih) vs `background` (warm off-white) — pendekatan ini **tidak bekerja** di dark mode karena dua warna gelap yang berdekatan cenderung melebur tanpa terlihat depth-nya. Karena itu, khusus dark mode:
- Card/surface diberi **1px `border`** halus (`#302D29`) sebagai pengganti kontras warna, BUKAN drop shadow tebal — prinsip *flat aesthetic* tetap dijaga.
- Jika border dirasa kurang, boleh naikkan *lightness* `surface` sedikit lagi (maks +2-3%), jangan gunakan shadow gelap karena akan tidak terlihat di atas background gelap.

### CTA & Tombol
Aturan "kontras ekstrem Hitam/Putih" pada Rules to Never Break tetap berlaku, hanya arahnya terbalik: tombol primary di dark mode memakai `primary-dark` (krem terang) dengan teks `secondary-dark` (nyaris hitam) di atasnya — bukan tetap hitam dengan teks putih, karena akan nyaris tak terlihat di atas canvas gelap.

### Floating Bottom Navigation (Glassmorphism)
Efek `backdrop-filter: blur` dipertahankan, namun opacity layer perlu dinaikkan sedikit (dari sentuhan tipis ke ~70-80% opacity gelap) agar tidak terlihat "kotor"/muddy saat blur bercampur dengan foto properti yang gelap di baliknya.

### Mekanisme Switching
- Default: ikuti *system preference* (`prefers-color-scheme`).
- Sediakan toggle manual di halaman Settings untuk override preferensi sistem.
- Semua token warna WAJIB direferensikan lewat CSS variable (bukan hex hardcoded) agar switching antar tema tidak memerlukan perubahan di level komponen.

### Rules to Never Break (Dark Mode)
- JANGAN gunakan pure black (`#000000`) sebagai `background` — selalu warm near-black agar konsisten dengan brand warmth.
- JANGAN pertahankan `primary` tetap hitam di dark mode — WAJIB dibalik ke terang agar CTA tetap paling menonjol di layar.
- JANGAN gunakan drop shadow gelap untuk separasi card; gunakan `border` tipis.
- SELALU uji kontras teks (`text-primary`/`text-secondary`) terhadap `background` dan `surface` dark agar tetap memenuhi WCAG AA.