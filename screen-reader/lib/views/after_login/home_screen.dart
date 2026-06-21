import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/response/book_res/book_res_model.dart';
import '../../res/app_colors.dart';
import '../../res/app_urls.dart';
import '../../view_model/after_login_ctr/home_controller.dart';
import '../custom_widgts/book_cover_widget.dart';
import 'package:screen_reader/utils/textstyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _ctrl = Get.put(HomeController());
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All',
    'Non-Fiction',
    'Fiction',
    'Productivity',
    'Philosophy',
    'Science',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.navyMid(context),
        onRefresh: () => _ctrl.retryAll(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            final name = _ctrl.weekBooks.isNotEmpty
                                ? '' // will come from profile controller eventually
                                : '';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good reading 👋',
                                  style: text14(
                                    color: AppColors.textMuted(context),
                                    context: context,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Discover Books',
                                  style: text26(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary(context),
                                    context: context,
                                  ),
                                ),
                              ],
                            );
                          }),
                          const Spacer(),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.navyMid(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.navyLight(context),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.textPrimary(context),
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search Bar
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.navyMid(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.navyLight(context),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.textMuted(context),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search books, authors…',
                                style: text15(
                                  color: AppColors.textMuted(context),
                                  context: context,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(6),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.accentDim,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: AppColors.accent,
                                size: 18,
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

            // ── Featured / Week Books ──────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeaderWidget(
                  title: 'Featured This Week',
                  onSeeAll: () {},
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Obx(() {
                if (_ctrl.isWeekLoading) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: _BookCardSkeleton(),
                  );
                }
                if (_ctrl.hasWeekError) {
                  return _ErrorWidget(
                    message: _ctrl.weekError,
                    onRetry: _ctrl.fetchWeekBooks,
                  );
                }
                if (_ctrl.weekBooks.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: _EmptyWidget(message: 'No featured books yet'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: _ApiFeaturedCard(book: _ctrl.weekBooks.first),
                );
              }),
            ),

            // ── Quick Actions ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  children: [
                    _quickAction(
                      context,
                      icon: Icons.nightlight_round,
                      label: 'Sleep\nTimer',
                      color: AppColors.coverPurple,
                    ),
                    const SizedBox(width: 10),
                    _quickAction(
                      context,
                      icon: Icons.speed_rounded,
                      label: 'Speed\nControl',
                      color: AppColors.coverBlue,
                    ),
                    const SizedBox(width: 10),
                    _quickAction(
                      context,
                      icon: Icons.bookmark_rounded,
                      label: 'Book\nmarks',
                      color: AppColors.coverGreen,
                    ),
                    const SizedBox(width: 10),
                    _quickAction(
                      context,
                      icon: Icons.equalizer_rounded,
                      label: 'Voice\nSettings',
                      color: AppColors.coverOrange,
                    ),
                  ],
                ),
              ),
            ),

            // ── Categories ────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child:
                        SectionHeaderWidget(title: 'Explore', onSeeAll: () {}),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _categories.length,
                      itemBuilder: (_, i) {
                        final selected = i == _selectedCategory;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.navyMid(context),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: selected
                                    ? AppColors.accent
                                    : AppColors.navyLight(context),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              _categories[i],
                              style: text14(
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? AppColors.navy(context)
                                    : AppColors.textMuted(context),
                                context: context,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── Books Grid ────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                if (_ctrl.isBooksLoading) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _GridSkeleton(),
                  );
                }
                if (_ctrl.hasBooksError) {
                  return _ErrorWidget(
                    message: _ctrl.booksError,
                    onRetry: _ctrl.fetchAllBooks,
                  );
                }
                if (_ctrl.books.isEmpty) {
                  return _EmptyWidget(message: 'No books available yet');
                }
                return null ?? const SizedBox.shrink();
              }),
            ),

            Obx(() {
              if (_ctrl.isBooksLoading || _ctrl.hasBooksError || _ctrl.books.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              final filtered = _selectedCategory == 0
                  ? _ctrl.books
                  : _ctrl.books
                      .where((b) =>
                          (b.category ?? '').toLowerCase().contains(
                              _categories[_selectedCategory].toLowerCase()))
                      .toList();
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _ApiBookCard(book: filtered[i]),
                    childCount: filtered.length,
                  ),
                ),
              );
            }),

            // ── Trending This Week (horizontal) ───────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: SectionHeaderWidget(
                  title: 'Trending This Week',
                  onSeeAll: () {},
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  if (_ctrl.isBooksLoading) {
                    return SizedBox(
                      height: 205,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (_, __) => const _TrendingSkeleton(),
                      ),
                    );
                  }
                  if (_ctrl.books.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 205,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _ctrl.books.length,
                      itemBuilder: (_, i) =>
                          _trendingCard(context, _ctrl.books[i]),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.navyMid(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.navyLight(context), width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: text12(
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted(context),
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trendingCard(BuildContext context, BookItem book) {
    final imageUrl = book.imageUrl.isNotEmpty
        ? '${AppUrls.baseUrl}${book.imageUrl}'
        : '';
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 145,
            decoration: BoxDecoration(
              color: AppColors.navyMid(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white30,
                          size: 52,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white30,
                        size: 52,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text16(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
              context: context,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            book.author,
            style: text13(
              color: AppColors.textMuted(context),
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}

// ── API Book Cards ─────────────────────────────────────────────────────────

class _ApiBookCard extends StatelessWidget {
  final BookItem book;
  const _ApiBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final imageUrl = book.imageUrl.isNotEmpty
        ? '${AppUrls.baseUrl}${book.imageUrl}'
        : '';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.navyLight(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.navyLight(context),
                        child: const Center(
                          child: Icon(Icons.menu_book_rounded,
                              color: Colors.white24, size: 42),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.navyLight(context),
                      child: const Center(
                        child: Icon(Icons.menu_book_rounded,
                            color: Colors.white24, size: 42),
                      ),
                    ),
            ),
          ),
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
                if (book.category != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentDim,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      book.category!,
                      style: text11(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        context: context,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiFeaturedCard extends StatelessWidget {
  final BookItem book;
  const _ApiFeaturedCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final imageUrl = book.imageUrl.isNotEmpty
        ? '${AppUrls.baseUrl}${book.imageUrl}'
        : '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyLight(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.18), width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 85,
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: AppColors.navyMid(context),
                          child: const Icon(Icons.menu_book_rounded,
                              color: Colors.white60, size: 30)))
                  : Container(
                      color: AppColors.navyMid(context),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white60, size: 30)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (book.category ?? 'BOOK').toUpperCase(),
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
                  book.author,
                  style: text14(
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '⭐ Book of the Week',
                    style: text11(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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

// ── Skeletons & Error/Empty Widgets ─────────────────────────────────────────

class _BookCardSkeleton extends StatelessWidget {
  const _BookCardSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.navyMid(context),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _TrendingSkeleton extends StatelessWidget {
  const _TrendingSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.navyMid(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 32),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text14(color: AppColors.textMuted(context), context: context),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Retry',
                  style: text14(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    context: context,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  final String message;
  const _EmptyWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Text(
          message,
          style: text14(color: AppColors.textMuted(context), context: context),
        ),
      ),
    );
  }
}
