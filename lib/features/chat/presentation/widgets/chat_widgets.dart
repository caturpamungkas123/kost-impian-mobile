import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import 'chat_data.dart';

/// Kumpulan widget chat — flat tanpa shadow, pill/rounded per DESIGN.md.
///
/// Tile inbox: avatar inisial + nama + nama kos + cuplikan + waktu +
/// badge belum dibaca + chip status pengajuan (prd.md §3.5).
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ChatConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final convo = conversation;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConversationAvatar(
              initials: convo.initials,
              isOnline: convo.isOnline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                convo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelSm.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (convo.isVerified) ...[
                              const SizedBox(width: 4),
                              FaIcon(
                                FontAwesomeIcons.circleCheck,
                                size: 13,
                                color: isLight
                                    ? AppColors.success
                                    : AppColors.darkSuccess,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        convo.time,
                        style: AppTypography.labelSm.copyWith(
                          fontSize: 11,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    convo.kosName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          convo.snippet,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMd.copyWith(
                            fontSize: 12,
                            color: muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (convo.unreadCount > 0)
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.primary,
                          ),
                          child: Text(
                            '${convo.unreadCount}',
                            style: AppTypography.labelSm.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: scheme.onPrimary,
                            ),
                          ),
                        )
                      else if (convo.sentByMe)
                        FaIcon(
                          FontAwesomeIcons.checkDouble,
                          size: 13,
                          color: muted,
                        ),
                    ],
                  ),
                  if (convo.bookingLabel != null) ...[
                    const SizedBox(height: 6),
                    BookingChip(label: convo.bookingLabel!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Avatar lingkaran inisial + titik online.
class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({
    super.key,
    required this.initials,
    this.size = 52,
    this.isOnline = false,
  });

  final String initials;
  final double size;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary.withValues(alpha: 0.08),
            border: Border.all(
              color: isLight ? AppColors.border : AppColors.darkBorder,
            ),
          ),
          child: Text(
            initials,
            style: AppTypography.labelSm.copyWith(
              fontSize: size * 0.32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLight ? AppColors.success : AppColors.darkSuccess,
                border: Border.all(
                  color: scheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Chip status pengajuan di tile inbox (info/observasi/booking).
class BookingChip extends StatelessWidget {
  const BookingChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final chipBg = isLight ? AppColors.tertiary : AppColors.darkTertiary;
    final dot = isLight ? AppColors.warning : AppColors.darkWarning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dot,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bubble teks — milikku: primary gelap; lawan bicara: surface + border.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final mine = message.isMine;

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: mine ? scheme.primary : scheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.md),
          topRight: const Radius.circular(AppRadius.md),
          bottomLeft: Radius.circular(mine ? AppRadius.md : 4),
          bottomRight: Radius.circular(mine ? 4 : AppRadius.md),
        ),
        border: mine
            ? null
            : Border.all(
                color: isLight ? AppColors.border : AppColors.darkBorder,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.text ?? '',
            style: AppTypography.bodyMd.copyWith(
              fontSize: 13,
              color: mine ? scheme.onPrimary : null,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.time,
                style: AppTypography.labelSm.copyWith(
                  fontSize: 10,
                  color: mine ? scheme.onPrimary.withValues(alpha: 0.7) : muted,
                ),
              ),
              if (mine) ...[
                const SizedBox(width: 4),
                FaIcon(
                  FontAwesomeIcons.checkDouble,
                  size: 11,
                  color: message.read
                      ? (isLight
                          ? AppColors.darkSuccess
                          : AppColors.darkSuccess)
                      : scheme.onPrimary.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    if (mine) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Flexible(child: bubble)],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const ConversationAvatar(initials: 'RD', size: 28),
        const SizedBox(width: 8),
        Flexible(child: bubble),
      ],
    );
  }
}

/// Kartu info kamar di dalam thread (hasil quick action "Info Kamar").
class RoomCardMessage extends StatelessWidget {
  const RoomCardMessage({
    super.key,
    this.info = dummyRoomInfo,
    required this.onChoose,
  });

  final ChatRoomInfo info;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.md),
                ),
                child: Image.network(
                  info.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 140,
                    alignment: Alignment.center,
                    color: isLight
                        ? AppColors.tertiary
                        : AppColors.darkTertiary,
                    child: FaIcon(
                      FontAwesomeIcons.bed,
                      size: 32,
                      color: muted,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isLight ? AppColors.error : AppColors.darkError,
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Text(
                    info.remainingLabel,
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${info.name} (${info.size})',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                info.price,
                style: AppTypography.labelSm.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            info.specs,
            style: AppTypography.labelSm.copyWith(
              fontSize: 11,
              color: muted,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onChoose,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.radiusFull,
              ),
              child: Text(
                'Pilih Kamar Ini  →',
                style: AppTypography.labelSm.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip status pengajuan di tengah thread (pending/diterima/ditolak).
class StatusChipMessage extends StatelessWidget {
  const StatusChipMessage({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final chipBg = isLight ? AppColors.tertiary : AppColors.darkTertiary;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: AppRadius.radiusFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.clock, size: 11, color: muted),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTypography.labelSm.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pil quick action di atas thread (Info Kamar / Observasi / Sewa).
class QuickPill extends StatelessWidget {
  const QuickPill({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final FaIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadius.radiusFull,
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 13),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bar input chat — tombol +, field pill, tombol kirim.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.surface,
              border: Border.all(color: border),
            ),
            child: const FaIcon(FontAwesomeIcons.plus, size: 16),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: AppRadius.radiusFull,
              border: Border.all(color: border),
            ),
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: AppTypography.bodyMd.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Ketik pesan atau pertanyaan...',
                hintStyle: AppTypography.bodyMd.copyWith(
                  fontSize: 13,
                  color: muted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onSend,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary,
            ),
            child: FaIcon(
              FontAwesomeIcons.paperPlane,
              size: 16,
              color: scheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pemisah tanggal di tengah thread.
class DateDivider extends StatelessWidget {
  const DateDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    return Center(
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          fontSize: 11,
          color: muted,
        ),
      ),
    );
  }
}

/// Tombol lingkaran kecil (back, telepon, titik tiga).
class ChatCircleButton extends StatelessWidget {
  const ChatCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final FaIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.surface,
          border: Border.all(
            color: isLight ? AppColors.border : AppColors.darkBorder,
          ),
        ),
        child: FaIcon(icon, size: 15),
      ),
    );
  }
}
