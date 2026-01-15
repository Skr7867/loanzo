import 'dart:developer';
import 'package:get/get.dart';
import '../../../data/response/status.dart';
import '../../../models/LoanList/loan_list_model.dart';
import '../../../repository/LoanList/loan_list_repository.dart';
import '../../services/user_session_service.dart';

class LoanListController extends GetxController {
  final LoanListRepository _repository = LoanListRepository();
  final UserSessionService _sessionService = UserSessionService();

  /// API STATE
  final Rx<Status> rxStatus = Status.LOADING.obs;
  final RxString errorMessage = ''.obs;

  /// DATA
  final RxList<Data> loanList = <Data>[].obs;

  /// FILTER
  final RxString selectedFilter = 'All Applications'.obs;
  final RxString searchQuery = ''.obs;

  /// PAGINATION
  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 6.obs;
  final RxInt totalItems = 0.obs;

  /// USER
  late final String userId;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments as String;
    fetchLoanList();
  }

  Future<void> fetchLoanList() async {
    try {
      rxStatus.value = Status.LOADING;

      final token = _sessionService.token;
      if (token == null || token.isEmpty) {
        throw Exception('Auth token not found');
      }

      final response = await _repository.loanList(token, userId);

      final List<Data> list = response.data ?? [];

      if (response.success == true) {
        loanList.assignAll(list);
        totalItems.value = list.length;
        rxStatus.value = Status.COMPLETED;
      } else {
        rxStatus.value = Status.ERROR;
        errorMessage.value = 'No loan applications found';
      }
    } catch (e, stack) {
      log('LoanListController → fetchLoanList', error: e, stackTrace: stack);
      rxStatus.value = Status.ERROR;
      errorMessage.value = e.toString();
    }
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    currentPage.value = 1; // Reset to first page when filter changes
  }

  void updateSearch(String value) {
    searchQuery.value = value.trim().toLowerCase();
    currentPage.value = 1; // Reset to first page when search changes
  }

  /// Get current page data
  List<Data> get currentPageData {
    final filteredList = filteredLoans();
    final startIndex = (currentPage.value - 1) * itemsPerPage.value;
    final endIndex = startIndex + itemsPerPage.value;

    if (startIndex >= filteredList.length) {
      return [];
    }

    return filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );
  }

  /// Get total pages
  int get totalPages {
    final filteredList = filteredLoans();
    return (filteredList.length / itemsPerPage.value).ceil();
  }

  /// Check if there's a next page
  bool get hasNextPage {
    return currentPage.value < totalPages;
  }

  /// Check if there's a previous page
  bool get hasPreviousPage {
    return currentPage.value > 1;
  }

  /// Go to next page
  void nextPage() {
    if (hasNextPage) {
      currentPage.value++;
    }
  }

  /// Go to previous page
  void previousPage() {
    if (hasPreviousPage) {
      currentPage.value--;
    }
  }

  /// Go to specific page
  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }

  /// Filter logic (copied from widget for controller access)
  List<Data> filteredLoans() {
    final filter = selectedFilter.value;
    final query = searchQuery.value.toLowerCase();

    return loanList.where((item) {
      /// -------- STAGE FILTER --------
      final bool matchesStage = filter == 'All Applications'
          ? true
          : item.applicationStatus?.currentStage == filter;

      /// -------- SEARCH FILTER --------
      if (query.isEmpty) return matchesStage;

      final brand = item.vehicleInfo?.vehicleBrand?.toLowerCase() ?? '';
      final model = item.vehicleInfo?.vehicleModel?.toLowerCase() ?? '';
      final amount = item.loanAmount?.toString() ?? '';
      final tenure = item.loanTenureMonths?.toString() ?? '';
      final stage = item.applicationStatus?.currentStage?.toLowerCase() ?? '';

      final bool matchesSearch =
          brand.contains(query) ||
          model.contains(query) ||
          amount.contains(query) ||
          tenure.contains(query) ||
          stage.contains(query);

      return matchesStage && matchesSearch;
    }).toList();
  }
}
