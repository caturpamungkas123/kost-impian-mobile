import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../kos_detail/presentation/pages/kos_detail_page.dart';
import 'chat_list_page.dart';
import '../widgets/chat_data.dart';
import '../widgets/chat_skeleton.dart';
import '../widgets/chat_widgets.dart';

/// Thread chat satu `conversation` (user_id, owner_id, kos_id — prd.md §3.5).
/// Berisi kartu konteks kos, quick action terstruktur (Info Kamar,
/// Ajukan Observasi, Ajukan Sewa — prd.md §7.3), bubble, dan input bar.
///
/// Referensi: Stitch `Chat & Interaksi Pemilik KosanKu`
/// (projects/3380788847386773914/screens/a5a16d6026e54699943ca5de07182d9c).
/// UI-first: dummy thread + kirim/quick-action lokal via StatefulWidget.
class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, this.conversationId});

  static const routeName = '/chat-detail';

  /// Id conversation dari inbox (via `extra`) — penentu header & kartu kos.
  final String? conversationId;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final List<ChatMessage> _messages = List.of(dummyThread);
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // Simulasi fetch awal — hapus saat BLoC tersedia, diganti state loading asli.
  bool _loading = true;
  int _localSeq = 0;

  ChatConversation get _convo {
    return dummyConversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => dummyConversations.first,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(kMockNetworkDelay, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _nextId() => 'local-${_localSeq++}';

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: _nextId(),
        isMine: true,
        text: text,
        time: 'Sekarang',
        read: false,
      ));
    });
    _inputController.clear();
    _scrollToBottom();
    FocusScope.of(context).unfocus();
  }

  /// Quick action "Info Kamar" — sisipkan kartu info kamar dari pemilik.
  void _sendRoomInfo() {
    setState(() {
      _messages.add(ChatMessage(
        id: _nextId(),
        isMine: false,
        type: ChatMessageType.roomCard,
        time: 'Sekarang',
      ));
    });
    _scrollToBottom();
  }

  /// Quick action "Ajukan Observasi" — tercatat dalam thread yang sama
  /// dengan status pending (prd.md §3.5), bukan record terpisah.
  void _sendObservation() {
    setState(() {
      _messages.add(ChatMessage(
        id: _nextId(),
        isMine: true,
        text: 'Halo, saya ingin mengajukan survei lokasi minggu ini. '
            'Apakah tanggal 26 Mei pagi tersedia?',
        time: 'Sekarang',
        read: false,
      ));
      _messages.add(const ChatMessage(
        id: 'local-status-obs',
        isMine: true,
        type: ChatMessageType.status,
        text: 'Pengajuan observasi • Menunggu konfirmasi',
        time: 'Sekarang',
      ));
    });
    _scrollToBottom();
  }

  /// Quick action "Ajukan Sewa" — booking tercatat dalam thread yang sama.
  void _sendBooking() {
    setState(() {
      _messages.add(ChatMessage(
        id: _nextId(),
        isMine: true,
        text: 'Saya ingin mengajukan sewa kamar Deluxe mulai awal bulan depan.',
        time: 'Sekarang',
        read: false,
      ));
      _messages.add(const ChatMessage(
        id: 'local-status-book',
        isMine: true,
        type: ChatMessageType.status,
        text: 'Pengajuan sewa • Menunggu konfirmasi',
        time: 'Sekarang',
      ));
    });
    _scrollToBottom();
  }

  void _chooseRoom() {
    setState(() {
      _messages.add(ChatMessage(
        id: _nextId(),
        isMine: true,
        text: 'Saya pilih Kamar Deluxe. Bagaimana langkah selanjutnya?',
        time: 'Sekarang',
        read: false,
      ));
    });
    _scrollToBottom();
  }

  Widget _buildMessage(ChatMessage message) {
    return switch (message.type) {
      ChatMessageType.text => ChatBubble(message: message),
      ChatMessageType.roomCard =>
        Row(children: [RoomCardMessage(onChoose: _chooseRoom)]),
      ChatMessageType.status =>
        StatusChipMessage(label: message.text ?? ''),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: SafeArea(child: ChatThreadSkeleton()),
      );
    }

    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final convo = _convo;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.gutter,
                0,
              ),
              child: _ThreadHeader(
                conversation: convo,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(ChatListPage.routeName),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.md,
                  AppSpacing.gutter,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KosContextCard(
                      conversation: convo,
                      onOpen: () => context.push(KosDetailPage.routeName),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          QuickPill(
                            icon: FontAwesomeIcons.circleInfo,
                            label: 'Info Kamar',
                            onTap: _sendRoomInfo,
                          ),
                          const SizedBox(width: 8),
                          QuickPill(
                            icon: FontAwesomeIcons.calendarCheck,
                            label: 'Ajukan Observasi',
                            onTap: _sendObservation,
                          ),
                          const SizedBox(width: 8),
                          QuickPill(
                            icon: FontAwesomeIcons.bagShopping,
                            label: 'Ajukan Sewa',
                            onTap: _sendBooking,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const DateDivider(label: 'Hari ini, 24 Mei'),
                    const SizedBox(height: AppSpacing.md),
                    for (var i = 0; i < _messages.length; i++) ...[
                      _buildMessage(_messages[i]),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.gutter,
                4,
              ),
              child: ChatInputBar(
                controller: _inputController,
                onSend: _send,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    size: 13,
                    color: Color(0xFF25D366),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Butuh respons cepat? ',
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 11,
                      color: muted,
                    ),
                  ),
                  GestureDetector(
                    // TODO: deep link wa.me nomor pemilik (pola _waLink Detail Kos).
                    onTap: () {},
                    child: Text(
                      'Chat via WhatsApp',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header thread: back + avatar/nama/kos + telepon + titik tiga.
class _ThreadHeader extends StatelessWidget {
  const _ThreadHeader({
    required this.conversation,
    required this.onBack,
  });

  final ChatConversation conversation;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    return Row(
      children: [
        ChatCircleButton(
          icon: FontAwesomeIcons.chevronLeft,
          onTap: onBack,
        ),
        const SizedBox(width: 10),
        ConversationAvatar(
          initials: conversation.initials,
          size: 44,
          isOnline: conversation.isOnline,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      conversation.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: AppRadius.radiusFull,
                    ),
                    child: Text(
                      'HOST PRO',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                conversation.kosName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSm.copyWith(
                  fontSize: 11,
                  color: muted,
                ),
              ),
            ],
          ),
        ),
        ChatCircleButton(icon: FontAwesomeIcons.ellipsis, onTap: () {}),
      ],
    );
  }
}

/// Kartu konteks kos di atas thread + tautan "Lihat Kos".
class _KosContextCard extends StatelessWidget {
  const _KosContextCard({
    required this.conversation,
    required this.onOpen,
  });

  final ChatConversation conversation;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.lg),
        ),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.md),
            ),
            child: Image.network(
              dummyRoomInfo.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                color: isLight ? AppColors.tertiary : AppColors.darkTertiary,
                child: FaIcon(
                  FontAwesomeIcons.house,
                  size: 20,
                  color: muted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.kosName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  dummyRoomInfo.price,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onOpen,
            child: Text(
              'Lihat Kos',
              style: AppTypography.labelSm.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
