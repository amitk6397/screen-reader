import 'package:screen_reader/data/api_response.dart';
import 'package:screen_reader/data/network/network_api_service.dart';
import 'package:screen_reader/model/response/book_res/book_res_model.dart';
import 'package:screen_reader/res/app_urls.dart';

class BookRepo {
  final _api = NetworkApiService();

  // ================== ALL ACTIVE BOOKS ==================
  Future<ApiResponse<BookResModel>> getBooks() async {
    try {
      final res = await _api.getApi(AppUrls.books);
      return ApiResponse.completed(BookResModel.fromJson(res));
    } catch (e) {
      return ApiResponse.error('Failed to fetch books');
    }
  }

  // ================== BOOKS OF THE WEEK ==================
  Future<ApiResponse<BookResModel>> getWeekBooks() async {
    try {
      final res = await _api.getApi(AppUrls.weekBooks);
      return ApiResponse.completed(BookResModel.fromJson(res));
    } catch (e) {
      return ApiResponse.error('Failed to fetch featured books');
    }
  }
}
