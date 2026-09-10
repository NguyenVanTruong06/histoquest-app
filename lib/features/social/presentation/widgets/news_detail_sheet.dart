import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/news_article_model.dart';
import '../../../../shared/widgets/bottom_sheet_wrapper.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Khung trượt hiển thị nội dung chi tiết bài viết lịch sử
class NewsDetailSheet extends StatefulWidget {
  final NewsArticleModel article;

  const NewsDetailSheet({
    super.key,
    required this.article,
  });

  static Future<void> show(BuildContext context, NewsArticleModel article) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailSheet(article: article),
    );
  }

  @override
  State<NewsDetailSheet> createState() => _NewsDetailSheetState();
}

class _NewsDetailSheetState extends State<NewsDetailSheet> {
  bool _isLiked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.article.initialLikes;
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return BottomSheetWrapper(
      title: article.category,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin tác giả & Thời gian
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(
                    Icons.history_edu_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.authorName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${article.publishedDate} · ${article.readTimeMinutes} phút đọc',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: _isLiked ? AppColors.danger : AppColors.textMuted,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                          _likes += _isLiked ? 1 : -1;
                        });
                      },
                    ),
                    Text(
                      '$_likes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isLiked ? AppColors.danger : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tiêu đề bài viết
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Đoạn trích danh ngôn / cổ thư nếu có
            if (article.historicalQuote != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                    left: BorderSide(
                      color: AppColors.primary,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          article.quoteAuthor ?? 'Cổ thư trích yếu',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${article.historicalQuote}"',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Nội dung bài viết đầy đủ
            Text(
              article.content,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // Danh sách thẻ tags
            if (article.tags.isNotEmpty) ...[
              const Text(
                'Từ khóa liên quan:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: article.tags.map((tag) {
                  return Chip(
                    label: Text('#$tag'),
                    backgroundColor: AppColors.background,
                    side: const BorderSide(color: AppColors.cardBorder),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Nút đóng / xác nhận đọc xong
            PrimaryButton(
              isFullWidth: true,
              label: 'Đã Đọc Xong · Nhận +15 XP',
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Bạn nhận được +15 XP từ việc đọc bài viết lịch sử!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
  }
}
