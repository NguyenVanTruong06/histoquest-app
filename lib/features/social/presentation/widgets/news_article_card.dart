import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/news_article_model.dart';
import '../../../../shared/widgets/app_card.dart';

/// Thẻ hiển thị một bài viết tin tức / kiến thức lịch sử
class NewsArticleCard extends StatefulWidget {
  final NewsArticleModel article;
  final VoidCallback onTap;

  const NewsArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  State<NewsArticleCard> createState() => _NewsArticleCardState();
}

class _NewsArticleCardState extends State<NewsArticleCard> {
  late bool _isLiked;
  late int _likesCount;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likesCount = widget.article.initialLikes;
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likesCount--;
      } else {
        _isLiked = true;
        _likesCount++;
      }
    });
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Đã lưu bài viết vào mục yêu thích!' : 'Đã bỏ lưu bài viết.',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header thẻ: Chuyên mục & Thời gian đọc
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.article.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.article.readTimeMinutes} phút đọc',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tiêu đề bài viết
          Text(
            widget.article.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Tóm tắt ngắn gọn
          Text(
            widget.article.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Tags chủ đề nếu có
          if (widget.article.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.article.tags.take(3).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ],

          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 10),

          // Footer thẻ: Tác giả, Ngày đăng & Nút tương tác
          Row(
            children: [
              // Thông tin tác giả
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.article.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            widget.article.publishedDate,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Thả Tim
              InkWell(
                onTap: _toggleLike,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18,
                        color: _isLiked ? AppColors.danger : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_likesCount',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isLiked ? AppColors.danger : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Nút Lưu bài
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  size: 20,
                  color: _isSaved ? AppColors.gold : AppColors.textMuted,
                ),
                onPressed: _toggleSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
