import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../profile/profile_screen.dart';
import '../widgets/booking_modal.dart';
import '../widgets/sos_panic_dialog.dart';

// ─── Golden yellow accent for the craving card (design-spec explicit) ───
const Color _kGoldenYellow = Color(0xFFF59E0B);

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softSurfaceGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                children: [
                  _buildUrgeCard(context),
                  const SizedBox(height: 22),
                  _buildSectionLabel('Human & Expert Support'),
                  const SizedBox(height: 12),
                  _buildConsultantCard(context),
                  const SizedBox(height: 14),
                  _buildPeerSupportCard(context),
                  const SizedBox(height: 22),
                  _buildSectionLabel('AI Support'),
                  const SizedBox(height: 12),
                  _buildAiAssistantCard(context),
                  const SizedBox(height: 22),
                  _buildCrisisFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 1. Top App Bar ───────────────────
  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 44),
          Expanded(
            child: Center(
              child: Text(
                'Support',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slateMuted,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            icon: const Icon(Icons.person_outline_rounded,
                color: AppColors.slateMuted, size: 24),
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            padding: EdgeInsets.zero,
            splashRadius: 22,
            tooltip: 'Your Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.slateMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  // ─────────────────── 2. Craving Card — Golden Yellow ───────────────────
  Widget _buildUrgeCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => SosPanicSheet.show(context),
        borderRadius: BorderRadius.circular(16),
        splashColor: _kGoldenYellow.withValues(alpha: 0.18),
        child: Container(
          decoration: BoxDecoration(
            color: _kGoldenYellow.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _kGoldenYellow.withValues(alpha: 0.60),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _kGoldenYellow.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "I'm having a craving",
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slateText,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Quick tools to help you get through the next 5 minutes',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.slateMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _kGoldenYellow.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _kGoldenYellow.withValues(alpha: 0.50),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.support_outlined,
                  color: _kGoldenYellow,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────── 3A. Consultant Card ───────────────────
  Widget _buildConsultantCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLightGray, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration banner
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, Color(0xFF0E4E7A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 30,
                      top: 8,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentCyan.withValues(alpha: 0.10),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: 14,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Transform.translate(
                            offset: const Offset(10, -36),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.softSurfaceGray,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      AppColors.accentCyan.withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.favorite_rounded,
                                      color: AppColors.danger, size: 11),
                                  SizedBox(width: 4),
                                  Text('We got this',
                                      style: TextStyle(
                                        color: AppColors.slateText,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 66,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.accentCyan
                                        .withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(Icons.person_rounded,
                                        color: AppColors.accentCyan, size: 22),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 4,
                                margin: const EdgeInsets.only(top: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.softSurfaceGray
                                      .withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.eco_rounded,
                                color: AppColors.primaryLight, size: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(14),
                    ),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.45),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam_rounded,
                          color: AppColors.accentCyan, size: 13),
                      SizedBox(width: 5),
                      Text('Online therapy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meet with a Consultant.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slateText,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Book a confidential session with a certified recovery specialist.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.slateMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _showBookingModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 15, color: AppColors.primaryBlue),
                        SizedBox(width: 8),
                        Text('Book a Session',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── 3B. Peer Support Card ───────────────────
  Widget _buildPeerSupportCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLightGray, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPeerChatSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.softSurfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.borderLightGray, width: 1),
                  ),
                  child: const Icon(Icons.people_outline_rounded,
                      color: AppColors.accentCyan, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Peer Support Chat',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slateText,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Connect anonymously with others currently on a similar recovery path.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.slateMuted,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Join Discussion →',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────── 4. AI Assistant Card ───────────────────
  Widget _buildAiAssistantCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLightGray, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showVentingChatSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(Icons.smart_toy_outlined,
                      color: AppColors.accentCyan, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My AI Assistant',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slateText,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No judgment, just a listening ear. Chat or vent anytime you need guidance.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.slateMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.slateMuted, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────── 5. Crisis Footer — SAMHSA only ───────────────────
  Widget _buildCrisisFooter(BuildContext context) {
    final helpline = AppConstants.nationalHelpline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.health_and_safety_rounded,
                color: AppColors.slateMuted, size: 14),
            const SizedBox(width: 6),
            const Text(
              '24/7 CRISIS SUPPORT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.slateMuted,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLightGray, width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.softSurfaceGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_in_talk_rounded,
                    color: AppColors.accentCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      helpline['title']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slateText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      helpline['number']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      helpline['description']!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.slateMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.35),
                  ),
                ),
                child: const Text(
                  'Call 24/7',
                  style: TextStyle(
                    color: AppColors.accentCyan,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BOOKING MODAL
  // Purpose dropdown, Calendar, Time dropdown, Format dropdown
  // ═══════════════════════════════════════════════════════════════
  void _showBookingModal(BuildContext context) {
    BookingModal.show(context);
  }

  // ═══════════════════════════════════════════════════════════════
  // PEER ANONYMOUS CHAT SHEET
  // ═══════════════════════════════════════════════════════════════
  void _showPeerChatSheet(BuildContext context) {
    final controller = TextEditingController();
    final List<Map<String, dynamic>> messages = [
      {
        'isPeer': true,
        'sender': 'Anonymous Member',
        'avatar': 'AM',
        'text':
            "Hey 👋 I'm here too. This community is a safe space — no judgment, no real names. What's on your mind?",
      },
    ];
    final quickPrompts = [
      "I'm really struggling today",
      "How do you handle cravings?",
      "I need some encouragement",
      "What keeps you going?",
    ];

    // Simulated peer responses keyed by keyword
    final List<Map<String, String>> peers = [
      {'name': 'Anonymous Member', 'avatar': 'AM'},
      {'name': 'Fellow Traveller', 'avatar': 'FT'},
      {'name': 'Recovery Friend', 'avatar': 'RF'},
    ];

    String getPeerReply(String input) {
      final lower = input.toLowerCase();
      if (lower.contains('crav') || lower.contains('urge')) {
        return "Cravings are brutal — I know. I usually run cold water over my wrists or chew ice. Sounds weird but it works. Hang tight 💪";
      } else if (lower.contains('struggle') || lower.contains('hard')) {
        return "Same here some days. The fact that you're reaching out instead of giving in is huge. Seriously, you're doing it right.";
      } else if (lower.contains('encour') || lower.contains('motivat')) {
        return "You made it through yesterday. That means you have everything you need to make it through today. One hour at a time 🙌";
      } else if (lower.contains('keep') || lower.contains('going')) {
        return "For me it's my kids. Also I started writing one thing I'm proud of each morning — even tiny stuff. It adds up.";
      } else {
        return "That resonates. A lot of us have been there. You're not alone in this — this community is proof of that. Keep talking 💬";
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            void sendMessage(String text) {
              if (text.trim().isEmpty) return;
              final clean = text.trim();
              controller.clear();
              setModalState(() => messages.add({
                    'isPeer': false,
                    'sender': 'You',
                    'avatar': 'ME',
                    'text': clean,
                  }));
              Future.delayed(const Duration(milliseconds: 800), () {
                if (!modalCtx.mounted) return;
                final peer = peers[messages.length % peers.length];
                setModalState(() => messages.add({
                      'isPeer': true,
                      'sender': peer['name'],
                      'avatar': peer['avatar'],
                      'text': getPeerReply(clean),
                    }));
              });
            }

            return Container(
              height: MediaQuery.of(modalCtx).size.height * 0.84,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalCtx).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: AppColors.softSurfaceGray,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                    top: BorderSide(
                        color: AppColors.borderLightGray, width: 1)),
              ),
              child: Column(
                children: [
                  // ── Sheet handle + header ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.borderLightGray,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyan
                                      .withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.people_outline_rounded,
                                    color: AppColors.accentCyan,
                                    size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Peer Support Chat',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.slateText,
                                      )),
                                  Text('Anonymous · Community · Safe Space',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.accentCyan,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ]),
                            IconButton(
                              onPressed: () => Navigator.pop(modalCtx),
                              icon: const Icon(Icons.close_rounded,
                                  color: AppColors.slateMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      height: 1, color: AppColors.borderLightGray),

                  // ── Message list ──
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (_, idx) {
                        final msg = messages[idx];
                        final isPeer = msg['isPeer'] as bool;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: isPeer
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              if (isPeer) ...[
                                // Peer avatar
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  child: Text(
                                    (msg['avatar'] as String),
                                    style: const TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: isPeer
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                                  children: [
                                    if (isPeer)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
                                        child: Text(
                                          msg['sender'] as String,
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.slateMuted,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(modalCtx)
                                                  .size
                                                  .width *
                                              0.74),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 11),
                                      decoration: BoxDecoration(
                                        color: isPeer
                                            ? AppColors.baseWhite
                                            : AppColors.accentCyan,
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              const Radius.circular(16),
                                          topRight:
                                              const Radius.circular(16),
                                          bottomLeft:
                                              Radius.circular(isPeer ? 4 : 16),
                                          bottomRight:
                                              Radius.circular(isPeer ? 16 : 4),
                                        ),
                                        border: Border.all(
                                          color: isPeer
                                              ? AppColors.borderLightGray
                                              : AppColors.accentCyan,
                                        ),
                                      ),
                                      child: Text(
                                        msg['text'] as String,
                                        style: TextStyle(
                                          color: isPeer
                                              ? AppColors.slateText
                                              : AppColors.primaryBlue,
                                          fontSize: 13.5,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // ── Quick prompts ──
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: Row(
                      children: quickPrompts.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(p,
                                style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.accentCyan,
                                    fontWeight: FontWeight.w600)),
                            backgroundColor:
                                AppColors.accentCyan.withValues(alpha: 0.08),
                            side: BorderSide(
                                color: AppColors.accentCyan
                                    .withValues(alpha: 0.35)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            onPressed: () => sendMessage(p),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Text input ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    decoration: const BoxDecoration(
                      color: AppColors.softSurfaceGray,
                      border: Border(
                          top: BorderSide(color: AppColors.borderLightGray)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.baseWhite,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                  color: AppColors.borderLightGray),
                            ),
                            child: TextField(
                              controller: controller,
                              style: const TextStyle(
                                  color: AppColors.slateText, fontSize: 14),
                              cursorColor: AppColors.accentCyan,
                              decoration: const InputDecoration(
                                hintText: 'Share with the community...',
                                hintStyle: TextStyle(
                                    color: AppColors.slateMuted,
                                    fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: sendMessage,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => sendMessage(controller.text),
                          icon: const Icon(Icons.send_rounded,
                              color: AppColors.accentCyan, size: 22),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // AI VENTING CHAT SHEET
  // ═══════════════════════════════════════════════════════════════
  void _showVentingChatSheet(BuildContext context) {
    final controller = TextEditingController();
    final List<Map<String, dynamic>> messages = [
      {
        'isAi': true,
        'text':
            "Hello, I'm your private venting companion. No judgment, just a listening ear. What's on your mind right now?",
      },
    ];
    final quickPrompts = [
      "I'm feeling a sudden craving",
      "I had a really stressful day",
      "I feel like no one understands",
      "I need a reminder why I'm doing this",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            void sendMessage(String text) {
              if (text.trim().isEmpty) return;
              final clean = text.trim();
              controller.clear();
              setModalState(
                  () => messages.add({'isAi': false, 'text': clean}));
              Future.delayed(const Duration(milliseconds: 600), () {
                if (!modalCtx.mounted) return;
                final lower = clean.toLowerCase();
                String reply;
                if (lower.contains('craving') || lower.contains('urge')) {
                  reply =
                      "Cravings are like waves — they peak and then they pass. Take three slow breaths with me. You've survived every one so far.";
                } else if (lower.contains('stress') ||
                    lower.contains('tired')) {
                  reply =
                      "You carried a heavy load today. Choosing to vent here instead of turning back is itself a win.";
                } else if (lower.contains('alone') ||
                    lower.contains('nobody')) {
                  reply =
                      "Isolation is one of the hardest parts. But you're not invisible here — thousands of members know exactly this feeling.";
                } else {
                  reply =
                      "Thank you for sharing. It takes courage to put real feelings into words. Take a slow breath — you're doing better than you think.";
                }
                setModalState(
                    () => messages.add({'isAi': true, 'text': reply}));
              });
            }

            return Container(
              height: MediaQuery.of(modalCtx).size.height * 0.82,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalCtx).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: AppColors.softSurfaceGray,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                    top: BorderSide(
                        color: AppColors.borderLightGray, width: 1)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.borderLightGray,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyan
                                      .withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.smart_toy_outlined,
                                    color: AppColors.accentCyan, size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('My AI Assistant',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.slateText,
                                      )),
                                  Text('Private · No judgment · 24/7',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.accentCyan,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ]),
                            IconButton(
                              onPressed: () => Navigator.pop(modalCtx),
                              icon: const Icon(Icons.close_rounded,
                                  color: AppColors.slateMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderLightGray),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (_, idx) {
                        final msg = messages[idx];
                        final isAi = msg['isAi'] as bool;
                        return Align(
                          alignment: isAi
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(modalCtx).size.width *
                                    0.78),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 11),
                            decoration: BoxDecoration(
                              color: isAi
                                  ? AppColors.baseWhite
                                  : AppColors.accentCyan,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft:
                                    Radius.circular(isAi ? 4 : 16),
                                bottomRight:
                                    Radius.circular(isAi ? 16 : 4),
                              ),
                              border: Border.all(
                                color: isAi
                                    ? AppColors.borderLightGray
                                    : AppColors.accentCyan,
                              ),
                            ),
                            child: Text(
                              msg['text'] as String,
                              style: TextStyle(
                                color: isAi
                                    ? AppColors.slateText
                                    : AppColors.primaryBlue,
                                fontSize: 13.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: Row(
                      children: quickPrompts.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(p,
                                style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.accentCyan,
                                    fontWeight: FontWeight.w600)),
                            backgroundColor:
                                AppColors.accentCyan.withValues(alpha: 0.08),
                            side: BorderSide(
                                color: AppColors.accentCyan
                                    .withValues(alpha: 0.35)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            onPressed: () => sendMessage(p),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    decoration: const BoxDecoration(
                      color: AppColors.softSurfaceGray,
                      border: Border(
                          top: BorderSide(color: AppColors.borderLightGray)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.baseWhite,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                  color: AppColors.borderLightGray),
                            ),
                            child: TextField(
                              controller: controller,
                              style: const TextStyle(
                                  color: AppColors.slateText, fontSize: 14),
                              cursorColor: AppColors.accentCyan,
                              decoration: const InputDecoration(
                                hintText: 'Type whatever you need to vent...',
                                hintStyle: TextStyle(
                                    color: AppColors.slateMuted,
                                    fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: sendMessage,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => sendMessage(controller.text),
                          icon: const Icon(Icons.send_rounded,
                              color: AppColors.accentCyan, size: 22),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
