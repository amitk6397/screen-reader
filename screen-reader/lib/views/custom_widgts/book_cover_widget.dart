import 'package:flutter/material.dart';

import '../../model/book_model.dart';
import '../../res/app_colors.dart';
import 'package:screen_reader/utils/textstyle.dart';

// ─────────────────────────────────────────────
// BOOK COVER WIDGET (Grid card)
// ─────────────────────────────────────────────
class BookCoverWidget extends StatelessWidget {
  final BookModel book;
  const BookCoverWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.navyLight(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover art
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Container(
                color: book.coverColor,
                width: double.infinity,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white24,
                        size: 52,
                      ),
                    ),
                    if (book.progress > 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: book.progress,
                          minHeight: 3,
                          backgroundColor: Colors.black26,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.accent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Book Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: text16(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                    context: context,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: text13(
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentDim,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        book.genre,
                        style: text11(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          context: context,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '4.8',
                      style: text12(
                        color: AppColors.textMuted(context),
                        fontWeight: FontWeight.w600,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FEATURED CARD WIDGET (Continue listening)
// ─────────────────────────────────────────────
class FeaturedCardWidget extends StatelessWidget {
  final BookModel book;
  const FeaturedCardWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyLight(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.18), width: 1),
      ),
      child: Row(
        children: [
          // Cover
          Container(
            width: 64,
            height: 85,
            decoration: BoxDecoration(
              color: book.coverColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white60,
              size: 32,
            ),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.genre.toUpperCase(),
                  style: text12(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    context: context,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  book.title,
                  style: text18(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                    context: context,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${book.author} • ${book.currentChapter}',
                  style: text14(
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: book.progress,
                    minHeight: 4,
                    backgroundColor: AppColors.navyMid(context),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(book.progress * 100).toInt()}% complete',
                  style: text11(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    context: context,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Play Button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER WIDGET
// ─────────────────────────────────────────────
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeaderWidget({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: text20(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
            context: context,
          ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: text14(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                context: context,
              ),
            ),
          ),
      ],
    );
  }
}
