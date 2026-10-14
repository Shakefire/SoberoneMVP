import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/community_post.dart';
import '../../providers/community_provider.dart';
import '../../providers/sobriety_provider.dart';
import '../profile/profile_screen.dart';
import '../widgets/certification_pledge_modal.dart';
import '../widgets/tracker_selection_drawer.dart';
import 'group_chat_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Global Top Navigation Tabs ('Following' removed as instructed)
  int _selectedTopTab = 0; // 0: Communities, 1: Groups
  final List<String> _topTabs = const ['Communities', 'Groups'];

  // Filter Pills for Communities View
  int _selectedFilterPill = 2; // 0: 'Day One', 1: '2 Days', 2: 'All milestones' (Page 1 default)
  final List<String> _filterPills = const ['Day One', '2 Days', 'All milestones'];

  bool _isTooltipVisible = true;
  final List<CommunityGroup> _groups = CommunityGroup.initialGroups;

  void _showCreateGroupSheet(BuildContext context) {
    final nameController = TextEditingController();
    String selectedEmoji = '🌿';
    final emojis = ['🌿', '🕊️', '🌱', '🧘', '🛡️', '⚡', '❤️', '🌟'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(modalCtx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.baseWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create Support Network',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                          letterSpacing: -0.3,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalCtx),
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.slateMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Start an open or private network without subscription paywalls.',
                    style: TextStyle(fontSize: 13, color: AppColors.slateMuted),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Group Badge',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: emojis.map((e) {
                      final isSelected = selectedEmoji == e;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedEmoji = e),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.cardSelectedBg
                                : AppColors.softSurfaceGray,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentCyan
                                  : AppColors.borderLightGray,
                              width: 1.5,
                            ),
                          ),
                          child: Text(e, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.slateText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Group name (e.g., Morning Mindful Circle)',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.slateMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.softSurfaceGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.borderLightGray),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          setState(() {
                            _groups.insert(
                              0,
                              CommunityGroup(
                                id: 'group_${DateTime.now().millisecondsSinceEpoch}',
                                name: name,
                                emoji: selectedEmoji,
                                lastMessage: 'You created the group. Welcome!',
                                lastMessageTime: 'Just now',
                                memberCount: 1,
                                messages: [
                                  ChatMessage(
                                    senderName: 'You',
                                    text: 'Welcome to $name! Excited to connect.',
                                    time: 'Just now',
                                    isMe: true,
                                  ),
                                ],
                              ),
                            );
                          });
                          Navigator.pop(modalCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primaryBlue,
                              content: Text('Network "$name" created! 🎉'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Group',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  void _showNewPostSheet(BuildContext context) {
    final textController = TextEditingController();
    final sobriety = context.read<SobrietyProvider>();
    final days = sobriety.profile.elapsedDays;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, -4),
                blurRadius: 20,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Share Your Story',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                        letterSpacing: -0.3,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.slateMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Share an achievement, a reflection, or reach out to fellow journeyers.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.slateMuted),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  maxLines: 4,
                  autofocus: true,
                  style: const TextStyle(
                    color: AppColors.slateText,
                    fontSize: 14.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'What inspired or challenged you today?',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.slateMuted,
                    ),
                    filled: true,
                    fillColor: AppColors.softSurfaceGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: AppColors.borderLightGray),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: AppColors.borderLightGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.accentCyan,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        context.read<CommunityProvider>().addPost(
                              authorName: 'You 🌟',
                              daysSober: days,
                              content: text,
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.primaryBlue,
                            content: Text('Story posted to the community! 🌟'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.baseWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text(
                      'Publish Story',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openCommentsModal(BuildContext context, CommunityPost post) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final bottomInset = MediaQuery.of(modalContext).viewInsets.bottom;
            return Container(
              height: MediaQuery.of(modalContext).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.baseWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F0C3C60),
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments (${post.comments.length})',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                            letterSpacing: -0.3,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.slateMuted),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.borderLightGray),
                  // Comments list
                  Expanded(
                    child: post.comments.isEmpty
                        ? const Center(
                            child: Text(
                              'No comments yet. Start the conversation!',
                              style: TextStyle(
                                  color: AppColors.slateMuted, fontSize: 13.5),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(18),
                            itemCount: post.comments.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final comment = post.comments[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.cardSelectedBg,
                                    child: Text(
                                      comment.authorName.isNotEmpty
                                          ? comment.authorName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.authorName,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          comment.text,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.slateText,
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        if (comment.isHearted) {
                                          comment.isHearted = false;
                                          comment.heartCount =
                                              (comment.heartCount - 1)
                                                  .clamp(0, 9999);
                                        } else {
                                          comment.isHearted = true;
                                          comment.heartCount += 1;
                                        }
                                      });
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          comment.isHearted
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          size: 15,
                                          color: comment.isHearted
                                              ? const Color(0xFFE11D48)
                                              : AppColors.slateMuted,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${comment.heartCount}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: comment.isHearted
                                                ? const Color(0xFFE11D48)
                                                : AppColors.slateMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                  // Keyboard input field
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, bottomInset + 12),
                    decoration: const BoxDecoration(
                      color: AppColors.baseWhite,
                      border: Border(
                          top: BorderSide(color: AppColors.borderLightGray)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.softSurfaceGray,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.borderLightGray),
                            ),
                            child: TextField(
                              controller: commentController,
                              autofocus: true,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.slateText),
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: TextStyle(
                                    fontSize: 13.5, color: AppColors.slateMuted),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            final text = commentController.text.trim();
                            if (text.isNotEmpty) {
                              setModalState(() {
                                post.comments.add(
                                  CommunityComment(
                                    authorName: 'You 👏',
                                    text: text,
                                    heartCount: 0,
                                  ),
                                );
                                commentController.clear();
                              });
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.send_rounded,
                              color: AppColors.primaryBlue),
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

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final activeSubstance = sobriety.profile.habitName;

    // View Routing:
    // Tab 0 ('Communities') ->
    //   Filter pill 2 ('All milestones') => Page 1: Milestones Overview
    //   Filter pill 0 ('Day One') or 1 ('2 Days') => Page 2: Stories Feed
    // Tab 1 ('Groups') -> Page 3: Redesigned Community Chat
    final isCommunities = _selectedTopTab == 0;
    final isMilestonesOverview = isCommunities && _selectedFilterPill == 2;
    final isStoriesFeed = isCommunities && _selectedFilterPill != 2;
    final isGroupsView = _selectedTopTab == 1;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.softSurfaceGray,
      drawer: const TrackerSelectionDrawer(),
      // Floating Action Button: large cyan '+' button hovering on bottom right of Stories Feed
      floatingActionButton: isStoriesFeed
          ? FloatingActionButton(
              onPressed: () => _showNewPostSheet(context),
              backgroundColor: AppColors.accentCyan, // Bright cyan per spec
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
          children: [
            // 1. Global Top Navigation (Menu: 'Communities', 'Groups' - 'Following' removed)
            _buildGlobalTopNav(context, isGroupsView),
            const SizedBox(height: 18),

            // If Groups tab is selected: Render Page 3
            if (isGroupsView) ...[
              _buildGroupsView(context),
            ]
            // Else Communities tab is selected:
            else ...[
              // 2. Context Header (Hamburger menu + active tracking context e.g. "Alcohol")
              _buildContextHeader(context, activeSubstance),
              const SizedBox(height: 16),

              // Filter Row: "Day One", "2 Days", "All milestones"
              _buildFilterPillRow(),
              const SizedBox(height: 20),

              // PAGE 1: Communities – Milestones Overview (when 'All milestones' is selected)
              if (isMilestonesOverview) ...[
                _buildMilestonesOverviewPage(context),
              ]
              // PAGE 2: Communities – Stories Feed (when 'Day One' or '2 Days' is selected)
              else ...[
                _buildStoriesFeedPage(context),
              ],
            ],
          ],
        ),
      ),
    );
  }

  // 1. Global Top Navigation: Horizontal flex row with "Communities" and "Groups" ('Following' removed)
  Widget _buildGlobalTopNav(BuildContext context, bool isGroupsView) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: Text tabs ("Communities", "Groups")
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_topTabs.length, (index) {
            final isSelected = _selectedTopTab == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTopTab = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _topTabs[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.slateMuted,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        // Right side:
        // In Groups view: "Create Group" icon (group silhouette with plus badge)
        // In Communities view: User profile silhouette icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGroupsView) ...[
              IconButton(
                tooltip: 'Create Group',
                onPressed: () => _showCreateGroupSheet(context),
                icon: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.group_add_rounded,
                    color: AppColors.accentCyan,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardSelectedBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentCyan, width: 1.5),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Context Header: Hamburger menu + dynamic title ("Alcohol")
  Widget _buildContextHeader(BuildContext context, String substance) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: AppColors.primaryBlue,
            size: 26,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        Text(
          substance,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }

  // Filter Pill Row: "Day One", "2 Days", "All milestones"
  Widget _buildFilterPillRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_filterPills.length, (index) {
          final isSelected = _selectedFilterPill == index;
          // In "All milestones" view, highlighted with bright cyan background per spec
          final isCyanHighlight = isSelected && index == 2;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilterPill = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isCyanHighlight
                      ? AppColors.accentCyan // Bright cyan background
                      : (isSelected
                          ? AppColors.primaryBlue
                          : AppColors.baseWhite),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCyanHighlight
                        ? AppColors.accentCyan
                        : (isSelected
                            ? AppColors.primaryBlue
                            : AppColors.borderLightGray),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  _filterPills[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.slateText,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // PAGE 1: Communities – Milestones Overview
  // --------------------------------------------------------------------------
  Widget _buildMilestonesOverviewPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Getting Sober Section: Bold header + "Day Zero" with grey hexagon & trailing chevron
        const Text(
          'Getting Sober',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '0', isBlue: false),
          title: 'Day Zero',
          onTap: () {},
        ),
        const SizedBox(height: 24),

        // 2. Reached Milestones Section: Completed "Day One" item with blue numbered hexagon
        // Directly below it is an action card: "Milestone needs review" + yellow pointing hand
        const Text(
          'Reached Milestones',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '1', isBlue: true),
          title: 'Day One',
          onTap: () {},
        ),
        const SizedBox(height: 10),
        // Action card: "Milestone needs review" with yellow pointing hand
        _buildActionReviewBanner(context),
        const SizedBox(height: 24),

        // 3. Upcoming Milestones Section: Stacked list of future goals with numbered grey icons
        const Text(
          'Upcoming Milestones',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '2', isBlue: false),
          title: '2 Days',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: '2 Days'),
        ),
        const SizedBox(height: 8),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '3', isBlue: false),
          title: '3 Days',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: '3 Days'),
        ),
        const SizedBox(height: 8),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '4', isBlue: false),
          title: '4 Days',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: '4 Days'),
        ),
        const SizedBox(height: 8),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '5', isBlue: false),
          title: 'Fiver • 5 days',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: '5 Days'),
        ),
        const SizedBox(height: 8),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '6', isBlue: false),
          title: '6 Days',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: '6 Days'),
        ),
        const SizedBox(height: 8),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '7', isBlue: false),
          title: '1 Week • 7 days',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: '1 Week'),
        ),
        const SizedBox(height: 8),
        _buildMilestoneOverviewCard(
          icon: _buildHexagonBadge(text: '90', isBlue: false),
          title: 'Day 90 • Professional Certification',
          onTap: () => CertificationPledgeModal.show(context, milestoneTitle: 'Day 90'),
        ),
      ],
    );
  }

  // Hexagon Badge Component (Blue for completed, Grey for upcoming/zero)
  Widget _buildHexagonBadge({required String text, required bool isBlue}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.hexagon_rounded,
          size: 38,
          color: isBlue
              ? AppColors.primaryBlue
              : const Color(0xFFCBD5E1), // Grey hexagon
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: isBlue ? Colors.white : AppColors.slateText,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneOverviewCard({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLightGray, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x040C3C60),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.slateMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionReviewBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening milestone review guidelines...'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLightGray, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x060C3C60),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            children: [
              // Yellow pointing-hand icon
              Icon(
                Icons.pan_tool_alt_rounded,
                color: AppColors.warning,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Milestone needs review',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.slateMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // PAGE 2: Communities – Stories Feed
  // --------------------------------------------------------------------------
  Widget _buildStoriesFeedPage(BuildContext context) {
    final community = context.watch<CommunityProvider>();
    final posts = community.posts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stories Header: Bold "Stories" title + user volume subtitle + settings/filter icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '21,763 people recently reached your next milestone',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.slateMuted,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filter & language settings'),
                    duration: Duration(milliseconds: 700),
                  ),
                );
              },
              icon: const Icon(
                Icons.tune_rounded,
                color: AppColors.primaryBlue,
                size: 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Information Tooltip: Prominent card explaining default language + arrow + "Okay" button
        if (_isTooltipVisible) ...[
          _buildInformationTooltip(),
          const SizedBox(height: 20),
        ],

        // Feed Content: Post cards with header, body, media, action bar, and top comment preview
        ...posts.map((post) => _buildPostCard(context, post)),
      ],
    );
  }

  Widget _buildInformationTooltip() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF), // Soft lavender/purple tint
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC4B5FD),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0C3C60),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Posts show in your default language (English). You can customize language preferences or view worldwide stories anytime.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: AppColors.slateText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Upward-pointing arrow toward settings icon
              Column(
                children: [
                  const Icon(
                    Icons.north_east_rounded,
                    color: Color(0xFF7C3AED), // Purple accent
                    size: 24,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Dismissible "Okay" button
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () => setState(() => _isTooltipVisible = false),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Okay',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // PAGE 3: Groups – Redesigned Community Chat
  // (Paywall removed, Create Group in header, active groups list, on-click transition to chat)
  // --------------------------------------------------------------------------
  Widget _buildGroupsView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peer Support Networks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Private group spaces with fellow journeyers.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.slateMuted,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showCreateGroupSheet(context),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('New Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Active Groups List
        ..._groups.map((group) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Transition to dedicated group chat interface
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupChatScreen(group: group),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.baseWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.borderLightGray,
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x040C3C60),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Group avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardSelectedBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentCyan.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          group.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Group info & last message preview
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    group.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryBlue,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                                Text(
                                  group.lastMessageTime,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.slateMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    group.lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.slateText,
                                    ),
                                  ),
                                ),
                                if (group.unreadCount > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${group.unreadCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.slateMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // REDESIGNED COMMUNITY POST CARD COMPONENT
  // --------------------------------------------------------------------------
  Widget _buildPostCard(BuildContext context, CommunityPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLightGray, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060C3C60),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Post Header: Horizontal flex row (Avatar left, stacked name + emoji & timestamp right)
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.cardSelectedBg,
                child: Text(
                  post.avatarInitials,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.slateMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Post Body (Text & Media)
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.slateText,
              height: 1.45,
            ),
          ),

          // Conditional Image Container (full-width, 8dp border radius, max height 240)
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: AppColors.softSurfaceGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.borderLightGray.withValues(alpha: 0.5),
                  ),
                ),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 160,
                      color: AppColors.softSurfaceGray,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: AppColors.cardSelectedBg,
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_outlined,
                              color: AppColors.accentCyan, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Milestone Moment Photo',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),

          // 3. Action Bar: Like Action, 24dp gap, Comment Action (Old "Add a comment" field removed)
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<CommunityProvider>().toggleCheer(post.id);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      post.isCheered
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: post.isCheered
                          ? const Color(0xFFE11D48)
                          : AppColors.slateMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.cheerCount}',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: post.isCheered
                            ? const Color(0xFFE11D48)
                            : AppColors.slateMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // 24dp gap between Like and Comment action
              const SizedBox(width: 24),

              GestureDetector(
                onTap: () => _openCommentsModal(context, post),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.slateMuted,
                      size: 19,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.comments.length}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 4. Top Comment Preview: Single most recent comment inside nested Soft Surface Gray box
          if (post.comments.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _openCommentsModal(context, post),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.softSurfaceGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.comments.last.authorName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            post.comments.last.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.slateText,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          post.comments.last.isHearted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 14,
                          color: post.comments.last.isHearted
                              ? const Color(0xFFE11D48)
                              : AppColors.slateMuted,
                        ),
                        if (post.comments.last.heartCount > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '${post.comments.last.heartCount}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: post.comments.last.isHearted
                                  ? const Color(0xFFE11D48)
                                  : AppColors.slateMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
