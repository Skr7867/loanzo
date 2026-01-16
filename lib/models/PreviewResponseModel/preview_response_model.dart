class PreViewResponseModel {
  bool? success;
  String? message;
  Data? data;

  PreViewResponseModel({this.success, this.message, this.data});

  PreViewResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  CreatedBy? createdBy;
  DtiCalculation? dtiCalculation;
  DownPaymentCapability? downPaymentCapability;
  PaymentHistoryAnalysis? paymentHistoryAnalysis;
  VehicleInfo? vehicleInfo;
  ApplicationStatus? applicationStatus;

  String? sId;
  String? userId;
  String? cibilScore;
  int? loanAmount;
  int? loanTenureMonths;
  String? occupation;
  int? monthlyIncome;

  List<String>? salarySlips; // ✅ FIXED
  String? itr;
  String? gstNum;
  List<String>? businessProof;
  int? creditUtilization;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? f16Document;

  Data.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    dtiCalculation = json['dtiCalculation'] != null
        ? DtiCalculation.fromJson(json['dtiCalculation'])
        : null;
    downPaymentCapability = json['downPaymentCapability'] != null
        ? DownPaymentCapability.fromJson(json['downPaymentCapability'])
        : null;
    paymentHistoryAnalysis = json['paymentHistoryAnalysis'] != null
        ? PaymentHistoryAnalysis.fromJson(json['paymentHistoryAnalysis'])
        : null;
    vehicleInfo = json['vehicleInfo'] != null
        ? VehicleInfo.fromJson(json['vehicleInfo'])
        : null;
    applicationStatus = json['applicationStatus'] != null
        ? ApplicationStatus.fromJson(json['applicationStatus'])
        : null;

    sId = json['_id'];
    userId = json['userId'];
    cibilScore = json['cibilScore'];
    loanAmount = (json['loanAmount'] as num?)?.toInt();
    loanTenureMonths = (json['loanTenureMonths'] as num?)?.toInt();
    occupation = json['occupation'];
    monthlyIncome = (json['monthlyIncome'] as num?)?.toInt();

    salarySlips = json['salarySlips'] != null
        ? List<String>.from(json['salarySlips'])
        : null;

    itr = json['itr'];
    gstNum = json['gstNum'];
    businessProof = json['businessProof'] != null
        ? List<String>.from(json['businessProof'])
        : null;

    creditUtilization = (json['creditUtilization'] as num?)?.toInt();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    f16Document = json['f16Document'];
  }

  Map<String, dynamic> toJson() {
    return {
      'createdBy': createdBy?.toJson(),
      'dtiCalculation': dtiCalculation?.toJson(),
      'downPaymentCapability': downPaymentCapability?.toJson(),
      'paymentHistoryAnalysis': paymentHistoryAnalysis?.toJson(),
      'vehicleInfo': vehicleInfo?.toJson(),
      'applicationStatus': applicationStatus?.toJson(),
      '_id': sId,
      'userId': userId,
      'cibilScore': cibilScore,
      'loanAmount': loanAmount,
      'loanTenureMonths': loanTenureMonths,
      'occupation': occupation,
      'monthlyIncome': monthlyIncome,
      'salarySlips': salarySlips,
      'itr': itr,
      'gstNum': gstNum,
      'businessProof': businessProof,
      'creditUtilization': creditUtilization,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'f16Document': f16Document,
    };
  }
}

class CreatedBy {
  String? userType;
  String? userId;

  CreatedBy({this.userType, this.userId});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    userType = json['userType'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['userId'] = this.userId;
    return data;
  }
}

class DtiCalculation {
  int? monthlyIncome;
  int? personalExpensePercentage;
  double? availableForEMI;
  int? currentEMICommitments;
  List<ExistingLoansBreakdown>? existingLoansBreakdown;
  double? availableEMICapacity;
  double? debtToIncomeRatio;
  int? maxEligibleLoanAmount;
  String? calculatedAt;

  DtiCalculation({
    this.monthlyIncome,
    this.personalExpensePercentage,
    this.availableForEMI,
    this.currentEMICommitments,
    this.existingLoansBreakdown,
    this.availableEMICapacity,
    this.debtToIncomeRatio,
    this.maxEligibleLoanAmount,
    this.calculatedAt,
  });

  DtiCalculation.fromJson(Map<String, dynamic> json) {
    monthlyIncome = (json['monthlyIncome'] as num?)?.toInt();
    personalExpensePercentage = (json['personalExpensePercentage'] as num?)
        ?.toInt();

    // Use helper method for type-safe conversion
    availableForEMI = _parseDouble(json['availableForEMI']);

    currentEMICommitments = (json['currentEMICommitments'] as num?)?.toInt();

    if (json['existingLoansBreakdown'] != null) {
      existingLoansBreakdown = <ExistingLoansBreakdown>[];
      json['existingLoansBreakdown'].forEach((v) {
        existingLoansBreakdown!.add(ExistingLoansBreakdown.fromJson(v));
      });
    }

    availableEMICapacity = _parseDouble(json['availableEMICapacity']);
    debtToIncomeRatio = _parseDouble(json['debtToIncomeRatio']);
    maxEligibleLoanAmount = (json['maxEligibleLoanAmount'] as num?)?.toInt();
    calculatedAt = json['calculatedAt'];
  }

  // Helper method to parse any type to double
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['monthlyIncome'] = monthlyIncome;
    data['personalExpensePercentage'] = personalExpensePercentage;
    data['availableForEMI'] = availableForEMI;
    data['currentEMICommitments'] = currentEMICommitments;

    if (existingLoansBreakdown != null) {
      data['existingLoansBreakdown'] = existingLoansBreakdown!
          .map((v) => v.toJson())
          .toList();
    }

    data['availableEMICapacity'] = availableEMICapacity;
    data['debtToIncomeRatio'] = debtToIncomeRatio;
    data['maxEligibleLoanAmount'] = maxEligibleLoanAmount;
    data['calculatedAt'] = calculatedAt;
    return data;
  }
}

class ExistingLoansBreakdown {
  String? accountType;
  String? lender;
  int? emiAmount;
  int? outstanding;
  String? sId;

  ExistingLoansBreakdown({
    this.accountType,
    this.lender,
    this.emiAmount,
    this.outstanding,
    this.sId,
  });

  ExistingLoansBreakdown.fromJson(Map<String, dynamic> json) {
    accountType = json['accountType'];
    lender = json['lender'];
    emiAmount = (json['emiAmount'] as num?)?.toInt();
    outstanding = (json['outstanding'] as num?)?.toInt();

    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountType'] = this.accountType;
    data['lender'] = this.lender;
    data['emiAmount'] = this.emiAmount;
    data['outstanding'] = this.outstanding;
    data['_id'] = this.sId;
    return data;
  }
}

class DownPaymentCapability {
  int? totalAmount;
  List<Sources>? sources;

  DownPaymentCapability({this.totalAmount, this.sources});

  DownPaymentCapability.fromJson(Map<String, dynamic> json) {
    totalAmount = (json['totalAmount'] as num?)?.toInt();

    if (json['sources'] != null) {
      sources = <Sources>[];
      json['sources'].forEach((v) {
        sources!.add(new Sources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    if (this.sources != null) {
      data['sources'] = this.sources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sources {
  String? sourceType;
  String? customName;
  List<String>? documents;
  int? amount;
  String? frequency;
  String? sId;

  Sources({
    this.sourceType,
    this.customName,
    this.documents,
    this.amount,
    this.frequency,
    this.sId,
  });

  Sources.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    customName = json['customName'];
    documents = json['documents'].cast<String>();
    amount = (json['amount'] as num?)?.toInt();

    frequency = json['frequency'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['customName'] = this.customName;
    data['documents'] = this.documents;
    data['amount'] = this.amount;
    data['frequency'] = this.frequency;
    data['_id'] = this.sId;
    return data;
  }
}

class PaymentHistoryAnalysis {
  SeverityBreakdown? severityBreakdown;
  int? totalBouncesOrDelays;
  int? recentBounces3Months;
  int? recentBounces6Months;
  List<String>? bounceIds; // ✅ FIXED
  String? snapshotAt;

  PaymentHistoryAnalysis.fromJson(Map<String, dynamic> json) {
    severityBreakdown = json['severityBreakdown'] != null
        ? SeverityBreakdown.fromJson(json['severityBreakdown'])
        : null;
    totalBouncesOrDelays = json['totalBouncesOrDelays'];
    recentBounces3Months = json['recentBounces3Months'];
    recentBounces6Months = json['recentBounces6Months'];

    bounceIds = json['bounceIds'] != null
        ? List<String>.from(json['bounceIds'])
        : null;

    snapshotAt = json['snapshotAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'severityBreakdown': severityBreakdown?.toJson(),
      'totalBouncesOrDelays': totalBouncesOrDelays,
      'recentBounces3Months': recentBounces3Months,
      'recentBounces6Months': recentBounces6Months,
      'bounceIds': bounceIds,
      'snapshotAt': snapshotAt,
    };
  }
}

class SeverityBreakdown {
  int? mild;
  int? moderate;
  int? severe;
  int? critical;

  SeverityBreakdown({this.mild, this.moderate, this.severe, this.critical});

  SeverityBreakdown.fromJson(Map<String, dynamic> json) {
    mild = json['mild'];
    moderate = json['moderate'];
    severe = json['severe'];
    critical = json['critical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mild'] = this.mild;
    data['moderate'] = this.moderate;
    data['severe'] = this.severe;
    data['critical'] = this.critical;
    return data;
  }
}

class VehicleInfo {
  String? vehicleType;
  String? vehicleBrand;
  String? vehicleModel;
  int? estimatedPrice;

  VehicleInfo({
    this.vehicleType,
    this.vehicleBrand,
    this.vehicleModel,
    this.estimatedPrice,
  });

  VehicleInfo.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicleType'];
    vehicleBrand = json['vehicleBrand'];
    vehicleModel = json['vehicleModel'];
    estimatedPrice = (json['estimatedPrice'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleType'] = this.vehicleType;
    data['vehicleBrand'] = this.vehicleBrand;
    data['vehicleModel'] = this.vehicleModel;
    data['estimatedPrice'] = this.estimatedPrice;
    return data;
  }
}

class ApplicationStatus {
  String? currentStage;
  String? stage1CompletedAt;
  String? finalDecision;
  String? stage2CompletedAt;

  ApplicationStatus({
    this.currentStage,
    this.stage1CompletedAt,
    this.finalDecision,
    this.stage2CompletedAt,
  });

  ApplicationStatus.fromJson(Map<String, dynamic> json) {
    currentStage = json['currentStage'];
    stage1CompletedAt = json['stage1CompletedAt'];
    finalDecision = json['finalDecision'];
    stage2CompletedAt = json['stage2CompletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentStage'] = this.currentStage;
    data['stage1CompletedAt'] = this.stage1CompletedAt;
    data['finalDecision'] = this.finalDecision;
    data['stage2CompletedAt'] = this.stage2CompletedAt;
    return data;
  }
}
