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

  void addComment(String postId, CommunityComment comment) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final updatedComments = List<CommunityComment>.from(post.comments)..add(comment);
      _posts[index] = CommunityPost(
        id: post.id,
        authorName: post.authorName,
        avatarInitials: post.avatarInitials,
        daysSober: post.daysSober,
        timeAgo: post.timeAgo,
        content: post.content,
        cheerCount: post.cheerCount,
        isCheered: post.isCheered,
        milestoneBadge: post.milestoneBadge,
        imageUrl: post.imageUrl,
        comments: updatedComments,
      );
      notifyListeners();
    }
  }

  void toggleCommentHeart(String postId, int commentIndex) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      if (commentIndex >= 0 && commentIndex < post.comments.length) {
        final comment = post.comments[commentIndex];
        if (comment.isHearted) {
          comment.isHearted = false;
          comment.heartCount = (comment.heartCount - 1).clamp(0, 9999);
        } else {
          comment.isHearted = true;
          comment.heartCount += 1;
        }
        notifyListeners();
      }
    }
  }

  void addPost({
    required String authorName,
    required int daysSober,
    required String content,
    String? milestoneBadge,
    String? imageUrl,
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
      imageUrl: imageUrl,
      comments: [],
    );

    _posts.insert(0, newPost);
    notifyListeners();
  }
}
