class LoanApplicationResponse {
  final bool success;
  final LoanApplicationData data;

  LoanApplicationResponse({required this.success, required this.data});

  factory LoanApplicationResponse.fromJson(Map<String, dynamic> json) {
    return LoanApplicationResponse(
      success: json['success'] ?? false,
      data: LoanApplicationData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class LoanApplicationData {
  final String id;
  final CreatedBy createdBy;
  final UserInfo userId;
  final CibilScore cibilScore;
  final DtiCalculation dtiCalculation;
  final DownPaymentCapability downPaymentCapability;
  final PaymentHistoryAnalysis paymentHistoryAnalysis;
  final ApplicationStatus applicationStatus;
  final int loanAmount;
  final int loanTenureMonths;
  final String occupation;
  final int monthlyIncome;
  final List<String> salarySlips;
  final String itr;
  final List<String> businessProof;
  final double creditUtilization;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  LoanApplicationData({
    required this.id,
    required this.createdBy,
    required this.userId,
    required this.cibilScore,
    required this.dtiCalculation,
    required this.downPaymentCapability,
    required this.paymentHistoryAnalysis,
    required this.applicationStatus,
    required this.loanAmount,
    required this.loanTenureMonths,
    required this.occupation,
    required this.monthlyIncome,
    required this.salarySlips,
    required this.itr,
    required this.businessProof,
    required this.creditUtilization,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LoanApplicationData.fromJson(Map<String, dynamic> json) {
    return LoanApplicationData(
      id: json['_id'] ?? '',
      createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}),
      userId: UserInfo.fromJson(json['userId'] ?? {}),
      cibilScore: CibilScore.fromJson(json['cibilScore'] ?? {}),
      dtiCalculation: DtiCalculation.fromJson(json['dtiCalculation'] ?? {}),
      downPaymentCapability: DownPaymentCapability.fromJson(
        json['downPaymentCapability'] ?? {},
      ),
      paymentHistoryAnalysis: PaymentHistoryAnalysis.fromJson(
        json['paymentHistoryAnalysis'] ?? {},
      ),
      applicationStatus: ApplicationStatus.fromJson(
        json['applicationStatus'] ?? {},
      ),
      loanAmount: json['loanAmount'] ?? 0,
      loanTenureMonths: json['loanTenureMonths'] ?? 0,
      occupation: json['occupation'] ?? '',
      monthlyIncome: json['monthlyIncome'] ?? 0,
      salarySlips: List<String>.from(json['salarySlips'] ?? []),
      itr: json['itr'] ?? '',
      businessProof: List<String>.from(json['businessProof'] ?? []),
      creditUtilization: (json['creditUtilization'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdBy': createdBy.toJson(),
      'userId': userId.toJson(),
      'cibilScore': cibilScore.toJson(),
      'dtiCalculation': dtiCalculation.toJson(),
      'downPaymentCapability': downPaymentCapability.toJson(),
      'paymentHistoryAnalysis': paymentHistoryAnalysis.toJson(),
      'applicationStatus': applicationStatus.toJson(),
      'loanAmount': loanAmount,
      'loanTenureMonths': loanTenureMonths,
      'occupation': occupation,
      'monthlyIncome': monthlyIncome,
      'salarySlips': salarySlips,
      'itr': itr,
      'businessProof': businessProof,
      'creditUtilization': creditUtilization,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class CreatedBy {
  final String userType;
  final String userId;

  CreatedBy({required this.userType, required this.userId});

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      userType: json['userType'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userType': userType, 'userId': userId};
  }
}

class UserInfo {
  final String id;
  final String name;
  final String? email;
  final int phone;

  UserInfo({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email, 'phone': phone};
  }
}

class DtiCalculation {
  final int monthlyIncome;
  final int personalExpensePercentage;
  final int availableForEMI;
  final int currentEMICommitments;
  final List<ExistingLoan> existingLoansBreakdown;
  final int availableEMICapacity;
  final double debtToIncomeRatio;
  final int maxEligibleLoanAmount;
  final DateTime calculatedAt;

  DtiCalculation({
    required this.monthlyIncome,
    required this.personalExpensePercentage,
    required this.availableForEMI,
    required this.currentEMICommitments,
    required this.existingLoansBreakdown,
    required this.availableEMICapacity,
    required this.debtToIncomeRatio,
    required this.maxEligibleLoanAmount,
    required this.calculatedAt,
  });

  factory DtiCalculation.fromJson(Map<String, dynamic> json) {
    return DtiCalculation(
      monthlyIncome: (json['monthlyIncome'] as num?)?.toInt() ?? 0,
      personalExpensePercentage:
          (json['personalExpensePercentage'] as num?)?.toInt() ?? 0,
      availableForEMI: (json['availableForEMI'] as num?)?.toInt() ?? 0,
      currentEMICommitments:
          (json['currentEMICommitments'] as num?)?.toInt() ?? 0,
      existingLoansBreakdown:
          (json['existingLoansBreakdown'] as List?)
              ?.map((e) => ExistingLoan.fromJson(e))
              .toList() ??
          [],
      availableEMICapacity:
          (json['availableEMICapacity'] as num?)?.toInt() ?? 0,
      debtToIncomeRatio: (json['debtToIncomeRatio'] as num?)?.toDouble() ?? 0.0,
      maxEligibleLoanAmount:
          (json['maxEligibleLoanAmount'] as num?)?.toInt() ?? 0,
      calculatedAt: DateTime.parse(
        json['calculatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthlyIncome': monthlyIncome,
      'personalExpensePercentage': personalExpensePercentage,
      'availableForEMI': availableForEMI,
      'currentEMICommitments': currentEMICommitments,
      'existingLoansBreakdown': existingLoansBreakdown
          .map((e) => e.toJson())
          .toList(),
      'availableEMICapacity': availableEMICapacity,
      'debtToIncomeRatio': debtToIncomeRatio,
      'maxEligibleLoanAmount': maxEligibleLoanAmount,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }
}

class ExistingLoan {
  final String id;
  final String accountType;
  final String lender;
  final int emiAmount;
  final int outstanding;

  ExistingLoan({
    required this.id,
    required this.accountType,
    required this.lender,
    required this.emiAmount,
    required this.outstanding,
  });

  factory ExistingLoan.fromJson(Map<String, dynamic> json) {
    return ExistingLoan(
      id: json['_id'] ?? '',
      accountType: json['accountType'] ?? '',
      lender: json['lender'] ?? '',
      emiAmount: json['emiAmount'] ?? 0,
      outstanding: json['outstanding'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'accountType': accountType,
      'lender': lender,
      'emiAmount': emiAmount,
      'outstanding': outstanding,
    };
  }
}

class DownPaymentCapability {
  final int totalAmount;
  final List<dynamic> sources;

  DownPaymentCapability({required this.totalAmount, required this.sources});

  factory DownPaymentCapability.fromJson(Map<String, dynamic> json) {
    return DownPaymentCapability(
      totalAmount: json['totalAmount'] ?? 0,
      sources: json['sources'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'totalAmount': totalAmount, 'sources': sources};
  }
}

class PaymentHistoryAnalysis {
  final SeverityBreakdown severityBreakdown;
  final int totalBouncesOrDelays;
  final int recentBounces3Months;
  final int recentBounces6Months;
  final List<dynamic> bounceIds;
  final DateTime snapshotAt;
  final List<dynamic> bounceDetails;

  PaymentHistoryAnalysis({
    required this.severityBreakdown,
    required this.totalBouncesOrDelays,
    required this.recentBounces3Months,
    required this.recentBounces6Months,
    required this.bounceIds,
    required this.snapshotAt,
    required this.bounceDetails,
  });

  factory PaymentHistoryAnalysis.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryAnalysis(
      severityBreakdown: SeverityBreakdown.fromJson(
        json['severityBreakdown'] ?? {},
      ),
      totalBouncesOrDelays: json['totalBouncesOrDelays'] ?? 0,
      recentBounces3Months: json['recentBounces3Months'] ?? 0,
      recentBounces6Months: json['recentBounces6Months'] ?? 0,
      bounceIds: json['bounceIds'] ?? [],
      snapshotAt: DateTime.parse(
        json['snapshotAt'] ?? DateTime.now().toIso8601String(),
      ),
      bounceDetails: json['bounceDetails'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severityBreakdown': severityBreakdown.toJson(),
      'totalBouncesOrDelays': totalBouncesOrDelays,
      'recentBounces3Months': recentBounces3Months,
      'recentBounces6Months': recentBounces6Months,
      'bounceIds': bounceIds,
      'snapshotAt': snapshotAt.toIso8601String(),
      'bounceDetails': bounceDetails,
    };
  }
}

class SeverityBreakdown {
  final int mild;
  final int moderate;
  final int severe;
  final int critical;

  SeverityBreakdown({
    required this.mild,
    required this.moderate,
    required this.severe,
    required this.critical,
  });

  factory SeverityBreakdown.fromJson(Map<String, dynamic> json) {
    return SeverityBreakdown(
      mild: json['mild'] ?? 0,
      moderate: json['moderate'] ?? 0,
      severe: json['severe'] ?? 0,
      critical: json['critical'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mild': mild,
      'moderate': moderate,
      'severe': severe,
      'critical': critical,
    };
  }
}

class ApplicationStatus {
  final String currentStage;
  final DateTime stage1CompletedAt;
  final String finalDecision;

  ApplicationStatus({
    required this.currentStage,
    required this.stage1CompletedAt,
    required this.finalDecision,
  });

  factory ApplicationStatus.fromJson(Map<String, dynamic> json) {
    return ApplicationStatus(
      currentStage: json['currentStage'] ?? '',
      stage1CompletedAt: DateTime.parse(
        json['stage1CompletedAt'] ?? DateTime.now().toIso8601String(),
      ),
      finalDecision: json['finalDecision'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStage': currentStage,
      'stage1CompletedAt': stage1CompletedAt.toIso8601String(),
      'finalDecision': finalDecision,
    };
  }
}

class CibilScore {
  final String id;
  final String userId;
  final RequestedBy requestedBy;
  final bool isAdminDirect;
  final DateTime reportGeneratedAt;
  final PersonalInfo personalInfo;
  final Score score;
  final List<Address> addresses;
  final List<Enquiry> enquiries;
  final List<Account> accounts;
  final CibilSummary summary;
  final CibilPaymentHistoryAnalysis paymentHistoryAnalysis;
  final RawData rawData;
  final String reportVersion;
  final String pdfUrl;
  final DateTime pdfGeneratedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CibilScore({
    required this.id,
    required this.userId,
    required this.requestedBy,
    required this.isAdminDirect,
    required this.reportGeneratedAt,
    required this.personalInfo,
    required this.score,
    required this.addresses,
    required this.enquiries,
    required this.accounts,
    required this.summary,
    required this.paymentHistoryAnalysis,
    required this.rawData,
    required this.reportVersion,
    required this.pdfUrl,
    required this.pdfGeneratedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CibilScore.fromJson(Map<String, dynamic> json) {
    return CibilScore(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      requestedBy: RequestedBy.fromJson(json['requestedBy'] ?? {}),
      isAdminDirect: json['isAdminDirect'] ?? false,
      reportGeneratedAt: DateTime.parse(
        json['reportGeneratedAt'] ?? DateTime.now().toIso8601String(),
      ),
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] ?? {}),
      score: Score.fromJson(json['score'] ?? {}),
      addresses:
          (json['addresses'] as List?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
      enquiries:
          (json['enquiries'] as List?)
              ?.map((e) => Enquiry.fromJson(e))
              .toList() ??
          [],
      accounts:
          (json['accounts'] as List?)
              ?.map((e) => Account.fromJson(e))
              .toList() ??
          [],
      summary: CibilSummary.fromJson(json['summary'] ?? {}),
      paymentHistoryAnalysis: CibilPaymentHistoryAnalysis.fromJson(
        json['paymentHistoryAnalysis'] ?? {},
      ),
      rawData: RawData.fromJson(json['rawData'] ?? {}),
      reportVersion: json['reportVersion'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      pdfGeneratedAt: DateTime.parse(
        json['pdfGeneratedAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'requestedBy': requestedBy.toJson(),
      'isAdminDirect': isAdminDirect,
      'reportGeneratedAt': reportGeneratedAt.toIso8601String(),
      'personalInfo': personalInfo.toJson(),
      'score': score.toJson(),
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'enquiries': enquiries.map((e) => e.toJson()).toList(),
      'accounts': accounts.map((e) => e.toJson()).toList(),
      'summary': summary.toJson(),
      'paymentHistoryAnalysis': paymentHistoryAnalysis.toJson(),
      'rawData': rawData.toJson(),
      'reportVersion': reportVersion,
      'pdfUrl': pdfUrl,
      'pdfGeneratedAt': pdfGeneratedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class RequestedBy {
  final String userType;
  final String userId;

  RequestedBy({required this.userType, required this.userId});

  factory RequestedBy.fromJson(Map<String, dynamic> json) {
    return RequestedBy(
      userType: json['userType'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userType': userType, 'userId': userId};
  }
}

class PersonalInfo {
  final String name;
  final String birthDate;
  final String pan;
  final String gender;
  final List<String> mobiles;
  final List<String> emails;

  PersonalInfo({
    required this.name,
    required this.birthDate,
    required this.pan,
    required this.gender,
    required this.mobiles,
    required this.emails,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] ?? '',
      birthDate: json['birthDate'] ?? '',
      pan: json['pan'] ?? '',
      gender: json['gender'] ?? '',
      mobiles: List<String>.from(json['mobiles'] ?? []),
      emails: List<String>.from(json['emails'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'pan': pan,
      'gender': gender,
      'mobiles': mobiles,
      'emails': emails,
    };
  }
}

class Score {
  final int value;
  final String date;
  final String scoreCardName;
  final List<ReasonCode> reasons;

  Score({
    required this.value,
    required this.date,
    required this.scoreCardName,
    required this.reasons,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      value: json['value'] ?? 0,
      date: json['date'] ?? '',
      scoreCardName: json['scoreCardName'] ?? '',
      reasons:
          (json['reasons'] as List?)
              ?.map((e) => ReasonCode.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'date': date,
      'scoreCardName': scoreCardName,
      'reasons': reasons.map((e) => e.toJson()).toList(),
    };
  }
}

class ReasonCode {
  final int code;
  final String name;

  ReasonCode({required this.code, required this.name});

  factory ReasonCode.fromJson(Map<String, dynamic> json) {
    return ReasonCode(code: json['code'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }
}

class Address {
  final int index;
  final int category;
  final String type;
  final String line1;
  final String line2;
  final int pinCode;
  final int stateCode;

  Address({
    required this.index,
    required this.category,
    required this.type,
    required this.line1,
    required this.line2,
    required this.pinCode,
    required this.stateCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      index: json['index'] ?? 0,
      category: json['category'] ?? 0,
      type: json['type'] ?? '',
      line1: json['line1'] ?? '',
      line2: json['line2'] ?? '',
      pinCode: json['pinCode'] ?? 0,
      stateCode: json['stateCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'category': category,
      'type': type,
      'line1': line1,
      'line2': line2,
      'pinCode': pinCode,
      'stateCode': stateCode,
    };
  }
}

class Enquiry {
  final String purpose;
  final String institution;
  final String date;

  Enquiry({
    required this.purpose,
    required this.institution,
    required this.date,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      purpose: json['purpose'] ?? '',
      institution: json['institution'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'purpose': purpose, 'institution': institution, 'date': date};
  }
}

class Account {
  final int accountIndex;
  final String accountType;
  final String memberShortName;
  final String accountNumberMasked;
  final String ownership;
  final String accountStatus;
  final String dateOpened;
  final String dateClosed;
  final String lastPaymentDate;
  final String lastBankUpdate;
  final int repaymentTenureMonths;
  final int emiAmount;
  final int currentBalance;
  final int highCreditAmount;
  final int amountOverdue;
  final String paymentFrequency;
  final String? interestRate;
  final List<MonthlyHistory> monthlyHistory;
  final int monthsReported;
  final List<dynamic> yearBuckets;

  Account({
    required this.accountIndex,
    required this.accountType,
    required this.memberShortName,
    required this.accountNumberMasked,
    required this.ownership,
    required this.accountStatus,
    required this.dateOpened,
    required this.dateClosed,
    required this.lastPaymentDate,
    required this.lastBankUpdate,
    required this.repaymentTenureMonths,
    required this.emiAmount,
    required this.currentBalance,
    required this.highCreditAmount,
    required this.amountOverdue,
    required this.paymentFrequency,
    this.interestRate,
    required this.monthlyHistory,
    required this.monthsReported,
    required this.yearBuckets,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountIndex: json['accountIndex'] ?? 0,
      accountType: json['accountType'] ?? '',
      memberShortName: json['memberShortName'] ?? '',
      accountNumberMasked: json['accountNumberMasked'] ?? '',
      ownership: json['ownership'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      dateOpened: json['dateOpened'] ?? '',
      dateClosed: json['dateClosed'] ?? '',
      lastPaymentDate: json['lastPaymentDate'] ?? '',
      lastBankUpdate: json['lastBankUpdate'] ?? '',
      repaymentTenureMonths: json['repaymentTenureMonths'] ?? 0,
      emiAmount: json['emiAmount'] ?? 0,
      currentBalance: json['currentBalance'] ?? 0,
      highCreditAmount: json['highCreditAmount'] ?? 0,
      amountOverdue: json['amountOverdue'] ?? 0,
      paymentFrequency: json['paymentFrequency'] ?? '',
      interestRate: json['interestRate'],
      monthlyHistory:
          (json['monthlyHistory'] as List?)
              ?.map((e) => MonthlyHistory.fromJson(e))
              .toList() ??
          [],
      monthsReported: json['monthsReported'] ?? 0,
      yearBuckets: json['yearBuckets'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountIndex': accountIndex,
      'accountType': accountType,
      'memberShortName': memberShortName,
      'accountNumberMasked': accountNumberMasked,
      'ownership': ownership,
      'accountStatus': accountStatus,
      'dateOpened': dateOpened,
      'dateClosed': dateClosed,
      'lastPaymentDate': lastPaymentDate,
      'lastBankUpdate': lastBankUpdate,
      'repaymentTenureMonths': repaymentTenureMonths,
      'emiAmount': emiAmount,
      'currentBalance': currentBalance,
      'highCreditAmount': highCreditAmount,
      'amountOverdue': amountOverdue,
      'paymentFrequency': paymentFrequency,
      'interestRate': interestRate,
      'monthlyHistory': monthlyHistory.map((e) => e.toJson()).toList(),
      'monthsReported': monthsReported,
      'yearBuckets': yearBuckets,
    };
  }
}

class MonthlyHistory {
  final String date;
  final String status;

  MonthlyHistory({required this.date, required this.status});

  factory MonthlyHistory.fromJson(Map<String, dynamic> json) {
    return MonthlyHistory(
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'status': status};
  }
}

class CibilSummary {
  final int totalActiveLoans;
  final int totalActiveCreditCards;
  final int totalLoanOutstanding;
  final int totalCardOutstanding;
  final int overduePaymentsCount;
  final String ageOfOldestAccount;
  final int recentEnquiriesCount3m;
  final int totalAccounts;

  CibilSummary({
    required this.totalActiveLoans,
    required this.totalActiveCreditCards,
    required this.totalLoanOutstanding,
    required this.totalCardOutstanding,
    required this.overduePaymentsCount,
    required this.ageOfOldestAccount,
    required this.recentEnquiriesCount3m,
    required this.totalAccounts,
  });

  factory CibilSummary.fromJson(Map<String, dynamic> json) {
    return CibilSummary(
      totalActiveLoans: json['totalActiveLoans'] ?? 0,
      totalActiveCreditCards: json['totalActiveCreditCards'] ?? 0,
      totalLoanOutstanding: json['totalLoanOutstanding'] ?? 0,
      totalCardOutstanding: json['totalCardOutstanding'] ?? 0,
      overduePaymentsCount: json['overduePaymentsCount'] ?? 0,
      ageOfOldestAccount: json['ageOfOldestAccount'] ?? '',
      recentEnquiriesCount3m: json['recentEnquiriesCount3m'] ?? 0,
      totalAccounts: json['totalAccounts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalActiveLoans': totalActiveLoans,
      'totalActiveCreditCards': totalActiveCreditCards,
      'totalLoanOutstanding': totalLoanOutstanding,
      'totalCardOutstanding': totalCardOutstanding,
      'overduePaymentsCount': overduePaymentsCount,
      'ageOfOldestAccount': ageOfOldestAccount,
      'recentEnquiriesCount3m': recentEnquiriesCount3m,
      'totalAccounts': totalAccounts,
    };
  }
}

class CibilPaymentHistoryAnalysis {
  final SeverityBreakdown severityBreakdown;
  final int totalBouncesOrDelays;
  final int recentBounces3Months;
  final int recentBounces6Months;
  final List<dynamic> allBounces;
  final List<dynamic> last6MonthsBounces;
  final DateTime analyzedAt;
  final String analysisVersion;

  CibilPaymentHistoryAnalysis({
    required this.severityBreakdown,
    required this.totalBouncesOrDelays,
    required this.recentBounces3Months,
    required this.recentBounces6Months,
    required this.allBounces,
    required this.last6MonthsBounces,
    required this.analyzedAt,
    required this.analysisVersion,
  });

  factory CibilPaymentHistoryAnalysis.fromJson(Map<String, dynamic> json) {
    return CibilPaymentHistoryAnalysis(
      severityBreakdown: SeverityBreakdown.fromJson(
        json['severityBreakdown'] ?? {},
      ),
      totalBouncesOrDelays: json['totalBouncesOrDelays'] ?? 0,
      recentBounces3Months: json['recentBounces3Months'] ?? 0,
      recentBounces6Months: json['recentBounces6Months'] ?? 0,
      allBounces: json['allBounces'] ?? [],
      last6MonthsBounces: json['last6MonthsBounces'] ?? [],
      analyzedAt: DateTime.parse(
        json['analyzedAt'] ?? DateTime.now().toIso8601String(),
      ),
      analysisVersion: json['analysisVersion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severityBreakdown': severityBreakdown.toJson(),
      'totalBouncesOrDelays': totalBouncesOrDelays,
      'recentBounces3Months': recentBounces3Months,
      'recentBounces6Months': recentBounces6Months,
      'allBounces': allBounces,
      'last6MonthsBounces': last6MonthsBounces,
      'analyzedAt': analyzedAt.toIso8601String(),
      'analysisVersion': analysisVersion,
    };
  }
}

class RawData {
  final RawDataContent data;
  final String statuscode;
  final bool success;
  final String? message;
  final String messageCode;
  final String cyRequestId;
  final String txnid;

  RawData({
    required this.data,
    required this.statuscode,
    required this.success,
    this.message,
    required this.messageCode,
    required this.cyRequestId,
    required this.txnid,
  });

  factory RawData.fromJson(Map<String, dynamic> json) {
    return RawData(
      data: RawDataContent.fromJson(json['data'] ?? {}),
      statuscode: json['statuscode'] ?? '',
      success: json['success'] ?? false,
      message: json['message'],
      messageCode: json['message_code'] ?? '',
      cyRequestId: json['cy-requestId'] ?? '',
      txnid: json['txnid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'statuscode': statuscode,
      'success': success,
      'message': message,
      'message_code': messageCode,
      'cy-requestId': cyRequestId,
      'txnid': txnid,
    };
  }
}

class RawDataContent {
  final String clientId;
  final String mobile;
  final String pan;
  final String name;
  final String gender;
  final String? userEmail;
  final String creditScore;
  final List<dynamic> creditReport;

  RawDataContent({
    required this.clientId,
    required this.mobile,
    required this.pan,
    required this.name,
    required this.gender,
    this.userEmail,
    required this.creditScore,
    required this.creditReport,
  });

  factory RawDataContent.fromJson(Map<String, dynamic> json) {
    return RawDataContent(
      clientId: json['client_id'] ?? '',
      mobile: json['mobile'] ?? '',
      pan: json['pan'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      userEmail: json['user_email'],
      creditScore: json['credit_score'] ?? '',
      creditReport: json['credit_report'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'mobile': mobile,
      'pan': pan,
      'name': name,
      'gender': gender,
      'user_email': userEmail,
      'credit_score': creditScore,
      'credit_report': creditReport,
    };
  }
}
