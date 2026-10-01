class CommunityPost {
  final String id;
  final String authorName;
  final String avatarInitials;
  final int daysSober;
  final String timeAgo;
  final String content;
  int cheerCount;
  bool isCheered;
  final String? milestoneBadge;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.avatarInitials,
    required this.daysSober,
    required this.timeAgo,
    required this.content,
    this.cheerCount = 0,
    this.isCheered = false,
    this.milestoneBadge,
  });

  static List<CommunityPost> get initialPosts => [
    CommunityPost(
      id: 'post_1',
      authorName: 'Alex M.',
      avatarInitials: 'AM',
      daysSober: 30,
      timeAgo: '12m ago',
      content:
          'Today marks 30 days! A month ago I honestly did not believe I could get through a single weekend. The cravings were intense in week one, but the 4-7-8 breathing here saved me multiple times. Keep going everyone!',
      cheerCount: 42,
      isCheered: false,
      milestoneBadge: '1 Month Champion',
    ),
    CommunityPost(
      id: 'post_2',
      authorName: 'Sarah K.',
      avatarInitials: 'SK',
      daysSober: 7,
      timeAgo: '1h ago',
      content:
          'Made it through my first full week. Waking up on a Sunday morning without brain fog or regrets feels like a superpower I forgot I had.',
      cheerCount: 28,
      isCheered: true,
      milestoneBadge: '1 Week Victorious',
    ),
    CommunityPost(
      id: 'post_3',
      authorName: 'David R.',
      avatarInitials: 'DR',
      daysSober: 92,
      timeAgo: '3h ago',
      content:
          'Just hit 3 months. My anxiety levels have cut in half, and I have saved over \$1,300 that I am using to take my daughter on a camping trip. If you are on day 1 or 2, hang in there. It gets so much easier.',
      cheerCount: 89,
      isCheered: false,
      milestoneBadge: '90 Days Reborn',
    ),
    CommunityPost(
      id: 'post_4',
      authorName: 'Elena V.',
      avatarInitials: 'EV',
      daysSober: 14,
      timeAgo: '5h ago',
      content:
          'Struggled a bit tonight at a dinner party, but stepped into the hallway, did a 3-minute check-in on SoberOne, and ordered sparkling water with lime. You are stronger than your impulses!',
      cheerCount: 35,
      isCheered: false,
    ),
  ];
}
