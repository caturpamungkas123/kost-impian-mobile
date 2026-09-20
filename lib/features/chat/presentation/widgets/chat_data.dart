import '../../../explore/presentation/widgets/kos_listing.dart';

/// Data chat — UI-first: dummy di presentation.
/// Nanti diganti entity `conversations`/`messages`/`bookings` + BLoC
/// (fase business logic, prd.md §3.5/§6).
///
/// Referensi: Stitch `Inbox Chat & Interaksi KosanKu`
/// (projects/3380788847386773914/screens/b5fa5111aec64e7c8eb580be96e3556d)
/// dan `Chat & Interaksi Pemilik KosanKu`
/// (projects/3380788847386773914/screens/a5a16d6026e54699943ca5de07182d9c).
class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.name,
    required this.kosName,
    required this.snippet,
    required this.time,
    this.unreadCount = 0,
    this.bookingLabel,
    this.isVerified = false,
    this.isOnline = false,
    this.sentByMe = false,
  });

  final String id;
  final String name;
  final String kosName;
  final String snippet;
  final String time;

  /// Jumlah pesan belum dibaca — tampil sebagai badge angka (prd.md §3.5).
  final int unreadCount;

  /// Label status pengajuan dalam thread (null bila percakapan teks biasa).
  final String? bookingLabel;
  final bool isVerified;
  final bool isOnline;

  /// Pesan terakhir dikirim oleh saya (tampilkan centang ganda).
  final bool sentByMe;

  /// Inisial avatar (2 huruf depan).
  String get initials {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return word.length >= 2 ? word.substring(0, 2) : word;
    }
    return '${parts[0][0]}${parts[1][0]}';
  }
}

const dummyConversations = [
  ChatConversation(
    id: 'ratna',
    name: 'Ibu Ratna Dewi',
    kosName: 'KosanKu Urban Kemang',
    snippet: 'Halo, masih tersedia 2 kamar untuk tipe Deluxe...',
    time: '09.44',
    bookingLabel: 'Info Kamar Terkonfirmasi',
    isVerified: true,
    isOnline: true,
  ),
  ChatConversation(
    id: 'hendra',
    name: 'Pak Hendra',
    kosName: 'Kos Harmoni Tebet',
    snippet: 'Jadwal survei tanggal 26 Mei telah disetujui...',
    time: 'Kemarin',
    bookingLabel: 'Observasi Dijadwalkan',
    sentByMe: true,
  ),
  ChatConversation(
    id: 'pavilion',
    name: 'Pengelola Pavilion Tebet',
    kosName: 'Pavilion Asri Tebet',
    snippet: 'Kamar tipe Standard sudah penuh, sisa tipe...',
    time: '22 Mei',
    sentByMe: true,
  ),
  ChatConversation(
    id: 'budi',
    name: 'Budi Santoso',
    kosName: 'Pavilion Asri Tebet',
    snippet: 'Halo Pak, saya ingin mengajukan sewa un...',
    time: '20 Mei',
    unreadCount: 1,
    bookingLabel: 'Menunggu Konfirmasi',
  ),
];

/// Jenis pesan terstruktur dalam thread (prd.md §3.5/§7.3) — bukan teks bebas.
enum ChatMessageType {
  /// Bubble teks biasa.
  text,

  /// Kartu info kamar (gambar + harga + tombol pilih).
  roomCard,

  /// Chip status pengajuan (pending/diterima) di tengah thread.
  status,
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.isMine,
    this.text,
    this.time = '09.44',
    this.type = ChatMessageType.text,
    this.read = true,
  });

  final String id;
  final bool isMine;
  final String? text;
  final String time;
  final ChatMessageType type;
  final bool read;
}

const dummyThread = [
  ChatMessage(
    id: 'm1',
    isMine: true,
    text: 'Halo Bu Ratna, apakah kamar tipe Deluxe '
        'masih tersedia untuk awal bulan depan?',
    time: '09.40',
  ),
  ChatMessage(
    id: 'm2',
    isMine: false,
    text: 'Halo! Masih tersedia 2 kamar untuk tipe Deluxe. '
        'Mau lihat info detail kamar atau langsung survei lokasi?',
    time: '09.44',
  ),
  ChatMessage(
    id: 'm3',
    isMine: false,
    type: ChatMessageType.roomCard,
    time: '09.44',
  ),
  ChatMessage(
    id: 'm4',
    isMine: true,
    text: 'Saya tertarik survei dulu Bu, '
        'tanggal 26 Mei pagi apakah bisa?',
    time: '09.47',
  ),
];

/// Kartu info kamar di dalam chat (quick action "Info Kamar").
class ChatRoomInfo {
  const ChatRoomInfo({
    required this.imageUrl,
    required this.name,
    required this.size,
    required this.price,
    required this.specs,
    required this.remainingLabel,
  });

  final String imageUrl;
  final String name;
  final String size;
  final String price;
  final String specs;
  final String remainingLabel;
}

const dummyRoomInfo = ChatRoomInfo(
  imageUrl: kosImageKemang,
  name: 'Kamar Deluxe',
  size: '3 x 4 m',
  price: 'Rp 2.450.000/bln',
  specs: 'AC Deluxe • K. Mandi Dalam • Kasur Queen • WiFi 100 Mbps',
  remainingLabel: 'Sisa 2 Kamar',
);
