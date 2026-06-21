import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_response.dart';
import '../../model/response/book_res/book_res_model.dart';
import '../../repo/book_repo.dart';
import '../../utils/custom_snackbar.dart';

/// Controller for the Home screen — loads all books and week-featured books.
class HomeController extends GetxController {
  final BookRepo _bookRepo = BookRepo();

  final Rx<ApiResponse<BookResModel>> booksResponse =
      ApiResponse<BookResModel>.loading().obs;

  final Rx<ApiResponse<BookResModel>> weekBooksResponse =
      ApiResponse<BookResModel>.loading().obs;

  List<BookItem> get books => booksResponse.value.data?.data ?? [];
  List<BookItem> get weekBooks => weekBooksResponse.value.data?.data ?? [];

  bool get isBooksLoading => booksResponse.value.status == Status.loading;
  bool get isWeekLoading => weekBooksResponse.value.status == Status.loading;
  bool get hasBooksError => booksResponse.value.status == Status.error;
  bool get hasWeekError => weekBooksResponse.value.status == Status.error;

  String get booksError => booksResponse.value.message ?? 'Failed to load books';
  String get weekError => weekBooksResponse.value.message ?? 'Failed to load featured books';

  @override
  void onInit() {
    super.onInit();
    fetchAllBooks();
    fetchWeekBooks();
  }

  Future<void> fetchAllBooks() async {
    booksResponse.value = ApiResponse<BookResModel>.loading();
    booksResponse.value = await _bookRepo.getBooks();
  }

  Future<void> fetchWeekBooks() async {
    weekBooksResponse.value = ApiResponse<BookResModel>.loading();
    weekBooksResponse.value = await _bookRepo.getWeekBooks();
  }

  /// Retry both book lists (used by error widget retry button)
  Future<void> retryAll() async {
    await Future.wait([fetchAllBooks(), fetchWeekBooks()]);
  }
}

/// Controller for the Library screen — shares book data from HomeController if available.
class LibraryController extends GetxController {
  final BookRepo _bookRepo = BookRepo();

  final Rx<ApiResponse<BookResModel>> booksResponse =
      ApiResponse<BookResModel>.loading().obs;

  List<BookItem> get books => booksResponse.value.data?.data ?? [];
  bool get isLoading => booksResponse.value.status == Status.loading;
  bool get hasError => booksResponse.value.status == Status.error;
  String get errorMessage => booksResponse.value.message ?? 'Failed to load books';

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    booksResponse.value = ApiResponse<BookResModel>.loading();
    booksResponse.value = await _bookRepo.getBooks();
  }
}
