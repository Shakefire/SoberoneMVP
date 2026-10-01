import 'package:flutter/foundation.dart';
import '../models/community_post.dart';

class CommunityProvider extends ChangeNotifier {
  final List<CommunityPost> _posts = [];

  List<CommunityPost> get posts => List.unmodifiable(_posts);

  CommunityProvider() {
    _posts.addAll(CommunityPost.initialPosts);
  }

  void toggleCheer(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      if (post.isCheered) {
        post.isCheered = false;
        post.cheerCount = (post.cheerCount - 1).clamp(0, 99999);
      } else {
        post.isCheered = true;
        post.cheerCount += 1;
      }
      notifyListeners();
    }
  }

  void addPost({
    required String authorName,
    required int daysSober,
    required String content,
    String? milestoneBadge,
  }) {
    final initials = authorName.trim().isEmpty
        ? 'ME'
        : authorName
            .trim()
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .take(2)
            .join();

    final newPost = CommunityPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName.isEmpty ? 'You' : authorName,
      avatarInitials: initials.isEmpty ? 'YO' : initials,
      daysSober: daysSober,
      timeAgo: 'Just now',
      content: content,
      cheerCount: 1,
      isCheered: true,
      milestoneBadge: milestoneBadge,
    );

    _posts.insert(0, newPost);
    notifyListeners();
  }
}
