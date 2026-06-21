import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/app_colors.dart';
import '../../view_model/after_login_ctr/book_reader_controller.dart';
import '../after_login/book_reader_screen.dart';
import 'package:screen_reader/utils/textstyle.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _filter = 0;
  final List<String> _filters = ['All', 'In Progress', 'Finished', 'Saved'];

  List<BookModel> get _filteredBooks {
    switch (_filter) {
      case 1:
        return sampleBooks.where((b) => b.status == 'in_progress').toList();
      case 2:
        return sampleBooks.where((b) => b.status == 'finished').toList();
      case 3:
        return sampleBooks.where((b) => b.status == 'saved').toList();
      default:
        return sampleBooks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Library',
                        style: text26(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                          context: context,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${sampleBooks.length} books • 3 in progress',
                        style: text14(
                          color: AppColors.textMuted(context),
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.navyMid(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.navyLight(context)),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (_, i) {
                  final isSelected = i == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.navyLight(context),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _filters[i],
                        style: text14(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.navy(context) // Dark text on accent
                              : AppColors.textMuted(context),
                          context: context,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Book List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredBooks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _LibraryItem(book: _filteredBooks[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Library Item
// ─────────────────────────────────────────────
class _LibraryItem extends StatelessWidget {
  final BookModel book;

  const _LibraryItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final reader = Get.put(ScreenReaderController());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.navyLight(context), width: 1),
      ),
      child: Row(
        children: [
          // Cover
          Container(
            width: 52,
            height: 70,
            decoration: BoxDecoration(
              color: book.coverColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white70,
              size: 26,
            ),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
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
                  style: text14(
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: book.progress,
                    minHeight: 4,
                    backgroundColor: AppColors.navyLight(context),
                    valueColor: AlwaysStoppedAnimation<Color>(book.coverColor),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(book.progress * 100).toInt()}% complete',
                  style: text12(
                    color: book.coverColor,
                    fontWeight: FontWeight.w600,
                    context: context,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Play Button
          GestureDetector(
            onTap: () {
              reader.stop();
              Get.to(
                () => BookReaderScreen(book: book),
                transition: Transition.cupertino,
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: book.coverColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: book.coverColor.withOpacity(0.4),
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: book.coverColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
