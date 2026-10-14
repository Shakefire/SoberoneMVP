import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChatMessage {
  final String senderName;
  final String text;
  final String time;
  final bool isMe;
  final String? mediaUrl;

  ChatMessage({
    required this.senderName,
    required this.text,
    required this.time,
    required this.isMe,
    this.mediaUrl,
  });
}

class CommunityGroup {
  final String id;
  final String name;
  final String emoji;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final int memberCount;
  final List<ChatMessage> messages;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.emoji,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.memberCount,
    required this.messages,
  });

  static List<CommunityGroup> get initialGroups => [
    CommunityGroup(
      id: 'group_1',
      name: 'Alcohol Freedom Circle',
      emoji: '🕊️',
      lastMessage: 'Sarah: Anyone free for a quick voice check-in?',
      lastMessageTime: '2m ago',
      unreadCount: 3,
      memberCount: 64,
      messages: [
        ChatMessage(
          senderName: 'David R.',
          text: 'Happy Sunday everyone. How are the weekend cravings holding up?',
          time: '10:14 AM',
          isMe: false,
        ),
        ChatMessage(
          senderName: 'You',
          text: 'Doing great here! Went for an early morning trail run instead of sleeping off a hangover.',
          time: '10:20 AM',
          isMe: true,
        ),
        ChatMessage(
          senderName: 'Elena V.',
          text: 'Love that for you! Sparkling water with lime has been my superpower at social gatherings.',
          time: '10:22 AM',
          isMe: false,
        ),
        ChatMessage(
          senderName: 'Sarah K.',
          text: 'Anyone free for a quick voice check-in later today?',
          time: '10:35 AM',
          isMe: false,
        ),
      ],
    ),
    CommunityGroup(
      id: 'group_2',
      name: 'Day 1 to 30 Beginners',
      emoji: '🌱',
      lastMessage: 'Marcus: Day 5 is proving tough, but reading your posts helps.',
      lastMessageTime: '18m ago',
      unreadCount: 1,
      memberCount: 112,
      messages: [
        ChatMessage(
          senderName: 'Alex M.',
          text: 'Welcome to all our new members who started this week! You are in the right place.',
          time: '8:45 AM',
          isMe: false,
        ),
        ChatMessage(
          senderName: 'Marcus T.',
          text: 'Day 5 is proving tough, but reading your posts helps a ton.',
          time: '9:02 AM',
          isMe: false,
        ),
      ],
    ),
    CommunityGroup(
      id: 'group_3',
      name: 'Mindful Living & Meditation',
      emoji: '🧘',
      lastMessage: 'Jessica: 10-minute morning breathwork done ✨',
      lastMessageTime: '1h ago',
      unreadCount: 0,
      memberCount: 89,
      messages: [
        ChatMessage(
          senderName: 'Jessica B.',
          text: '10-minute morning breathwork done ✨ Sending peace to everyone today.',
          time: '7:30 AM',
          isMe: false,
        ),
      ],
    ),
    CommunityGroup(
      id: 'group_4',
      name: 'Weekend Support Squad',
      emoji: '🛡️',
      lastMessage: 'Carlos: Replaced beer with zero-proof ginger beer!',
      lastMessageTime: '3h ago',
      unreadCount: 0,
      memberCount: 45,
      messages: [
        ChatMessage(
          senderName: 'Carlos M.',
          text: 'Replaced beer with zero-proof ginger beer and feeling fantastic!',
          time: 'Yesterday',
          isMe: false,
        ),
      ],
    ),
  ];
}

class GroupChatScreen extends StatefulWidget {
  final CommunityGroup group;

  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.group.messages.add(
        ChatMessage(
          senderName: 'You',
          text: text,
          time: 'Just now',
          isMe: true,
        ),
      );
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softSurfaceGray,
      appBar: AppBar(
        backgroundColor: AppColors.baseWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.cardSelectedBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.group.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    '${widget.group.memberCount} members • Online',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.slateMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.slateMuted),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Message Thread List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: widget.group.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.group.messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Bottom Chat Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(
              14,
              10,
              14,
              MediaQuery.of(context).padding.bottom + 10,
            ),
            decoration: const BoxDecoration(
              color: AppColors.baseWhite,
              border: Border(
                top: BorderSide(color: AppColors.borderLightGray),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_photo_alternate_rounded,
                      color: AppColors.slateMuted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.softSurfaceGray,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.borderLightGray),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.slateText,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Message group...',
                        hintStyle: TextStyle(
                          fontSize: 13.5,
                          color: AppColors.slateMuted,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
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

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 50),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                msg.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                msg.time,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 50),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.baseWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          border: Border.all(color: AppColors.borderLightGray),
          boxShadow: const [
            BoxShadow(
              color: Color(0x040C3C60),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.senderName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.accentCyan,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              msg.text,
              style: const TextStyle(
                color: AppColors.slateText,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              msg.time,
              style: const TextStyle(
                color: AppColors.slateMuted,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
