import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

/// Model for each Down Payment Source
class DownPaymentSource {
  RxnString sourceType = RxnString();
  RxString amount = ''.obs;
  RxString frequency = 'Monthly'.obs;
  Rx<File?> document = Rx<File?>(null);
}

class CheckEligibilityController extends GetxController {
  /// ================= Vehicle Info =================
  RxString vehicleType = 'Four-wheeler'.obs; // Changed to match backend
  RxString selectedBrand = ''.obs;
  RxString vehicleModel = ''.obs;
  RxString estimatedPrice = ''.obs;

  /// ================= F16 Document =================
  Rx<File?> f16Document = Rx<File?>(null);

  /// ================= Down Payment Sources =================
  RxList<DownPaymentSource> sources = <DownPaymentSource>[
    DownPaymentSource(),
  ].obs;

  // Updated to match backend format
  final List<String> vehicleTypes = ['Four-wheeler']; // Changed to hyphen

  final List<String> vehicleBrands = [
    'Maruti Suzuki',
    'Hyundai',
    'Tata',
    'Mahindra',
    'Honda',
    'Toyota',
    'Kia',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Other',
  ];

  final List<String> sourceTypes = [
    'Rental Income',
    'PF/EPF',
    'Side Business',
    'Freelance',
    'Investment Returns',
    'Gifts',
    'Other',
  ];

  final List<String> frequencies = ['Monthly', 'Yearly'];

  /// ================= Actions =================

  void addSource() {
    sources.add(DownPaymentSource());
  }

  void removeF16Document() {
    f16Document.value = null;
  }

  void removeSourceDocument(int index) {
    sources[index].document.value = null;
  }

  void removeSource(int index) {
    if (sources.length > 1) {
      sources.removeAt(index);
    }
  }

  /// Pick F16 PDF
  Future<void> pickF16Document() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      f16Document.value = File(result.files.single.path!);
    }
  }

  /// Pick document for source
  Future<void> pickSourceDocument(int index) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      sources[index].document.value = File(result.files.single.path!);
    }
  }

  /// Calculate total
  int get totalDownPayment {
    int total = 0;
    for (var source in sources) {
      final value = int.tryParse(source.amount.value.replaceAll(',', '')) ?? 0;
      total += value;
    }
    return total;
  }
}
