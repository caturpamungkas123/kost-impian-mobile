import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/page_title.dart';
import '../../../explore/presentation/widgets/explore_widgets.dart'
    show FilterPills;
import 'chat_detail_page.dart';
import '../widgets/chat_data.dart';
import '../widgets/chat_skeleton.dart';
import '../widgets/chat_widgets.dart';

/// Inbox chat — daftar `conversations` milik pengguna (prd.md §3.5/§4.7).
/// Tab tersendiri di bottom nav (bukan bubble mengambang), satu pengguna
/// bisa punya banyak thread — shortcut "Chat di Aplikasi" di Detail Kos
/// langsung membuka thread yang sesuai.
///
/// Referensi: Stitch `Inbox Chat & Interaksi KosanKu`
/// (projects/3380788847386773914/screens/b5fa5111aec64e7c8eb580be96e3556d).
/// UI-first: dummy + state lokal (search, filter, tutup banner).
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  static const routeName = '/chat';

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  static const _filters = ['Semua', 'Belum Dibaca', 'Pengajuan/Booking'];

  String _selectedFilter = _filters[0];
  String _query = '';
  bool _bannerVisible = true;
  // Simulasi fetch awal — hapus saat BLoC tersedia, diganti state loading asli.
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(kMockNetworkDelay, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  List<ChatConversation> get _filtered {
    return dummyConversations.where((convo) {
      final matchFilter = switch (_selectedFilter) {
        'Belum Dibaca' => convo.unreadCount > 0,
        'Pengajuan/Booking' => convo.bookingLabel != null,
        _ => true,
      };
      final q = _query.trim().toLowerCase();
      final matchQuery = q.isEmpty ||
          convo.name.toLowerCase().contains(q) ||
          convo.kosName.toLowerCase().contains(q) ||
          convo.snippet.toLowerCase().contains(q);
      return matchFilter && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: ChatListSkeleton());
    }

    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final results = _filtered;
    final activeCount = dummyConversations.length;

    // Bottom nav disediakan permanen oleh AppShell — halaman ini hanya konten.
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          120, // inset bawah anti-tertutup bottom nav shell (DESIGN.md)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageTitle('Pesan & Interaksi'),
                    Text(
                      '$activeCount percakapan aktif terhubung',
                      style: AppTypography.bodyMd.copyWith(
                        fontSize: 12,
                        color: muted,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _CircleIconButton(
                      icon: FontAwesomeIcons.magnifyingGlass,
                      border: border,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _CircleIconButton(
                      icon: FontAwesomeIcons.ellipsis,
                      border: border,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _SearchBar(
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilterPills(
              filters: _filters,
              selected: _selectedFilter,
              onSelected: (f) => setState(() => _selectedFilter = f),
            ),
            if (_bannerVisible) ...[
              const SizedBox(height: AppSpacing.md),
              _HintBanner(
                onClose: () => setState(() => _bannerVisible = false),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    'Tidak ada percakapan yang cocok.',
                    style: AppTypography.bodyMd.copyWith(color: muted),
                  ),
                ),
              )
            else
              for (var i = 0; i < results.length; i++) ...[
                if (i > 0) Divider(height: 1, color: border),
                ConversationTile(
                  conversation: results[i],
                  onTap: () => context.push(
                    ChatDetailPage.routeName,
                    extra: results[i].id,
                  ),
                ),
              ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.lock, size: 11, color: muted),
                const SizedBox(width: 6),
                Text(
                  'Semua percakapan terenkripsi secara end-to-end',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 11,
                    color: muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.radiusFull,
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16, color: muted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTypography.bodyMd.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari nama pemilik, nama kos, atau pesan...',
                hintStyle: AppTypography.bodyMd.copyWith(
                  fontSize: 13,
                  color: muted,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner petunjuk "Chat di Aplikasi" — bisa ditutup (state lokal).
class _HintBanner extends StatelessWidget {
  const _HintBanner({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.lg),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Ingin langsung tanya kos? Buka detail properti dan klik '
              'tombol "Chat di Aplikasi" untuk diskusi instan dengan pemilik.',
              style: AppTypography.bodyMd.copyWith(
                fontSize: 12,
                color: scheme.onPrimary.withValues(alpha: 0.92),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClose,
            child: FaIcon(
              FontAwesomeIcons.xmark,
              size: 14,
              color: scheme.onPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.border,
    required this.onTap,
  });

  final FaIconData icon;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: border),
        ),
        child: FaIcon(icon, size: 15),
      ),
    );
  }
}
