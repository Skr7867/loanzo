class CamReportModel {
  bool? success;
  bool? hasCam;
  String? message;
  Data? data;

  CamReportModel({this.success, this.hasCam, this.message, this.data});

  CamReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    hasCam = json['hasCam'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['hasCam'] = hasCam;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? camInputId;
  User? user;
  Inputs? inputs;
  CamReport? camReport;
  String? pdfUrl;
  String? createdAt;
  String? updatedAt;

  Data({
    this.camInputId,
    this.user,
    this.inputs,
    this.camReport,
    this.pdfUrl,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    camInputId = json['camInputId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    inputs = json['inputs'] != null ? Inputs.fromJson(json['inputs']) : null;
    camReport = json['camReport'] != null
        ? CamReport.fromJson(json['camReport'])
        : null;
    pdfUrl = json['pdfUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['camInputId'] = camInputId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (inputs != null) {
      data['inputs'] = inputs!;
    }
    if (camReport != null) {
      data['camReport'] = camReport!.toJson();
    }
    data['pdfUrl'] = pdfUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? email; // Changed from Null? to String?
  int? phone;

  User({this.sId, this.name, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Inputs {
  String? employmentType;
  double? monthlyIncome; // ✅ change to double
  InputOtherObligations? otherObligations;

  Inputs({this.employmentType, this.monthlyIncome, this.otherObligations});

  Inputs.fromJson(Map<String, dynamic> json) {
    employmentType = json['employmentType'];

    // ✅ SAFE conversion (handles int & double)
    monthlyIncome = json['monthlyIncome']?.toDouble();

    otherObligations = json['otherObligations'] != null
        ? InputOtherObligations.fromJson(json['otherObligations'])
        : null;
  }
}

// Renamed to avoid conflict with other OtherObligations class
class InputOtherObligations {
  bool? hasOther;
  int? amount;

  InputOtherObligations({this.hasOther, this.amount});

  InputOtherObligations.fromJson(Map<String, dynamic> json) {
    hasOther = json['hasOther'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasOther'] = hasOther;
    data['amount'] = amount;
    return data;
  }
}

class CamReport {
  String? reportGeneratedAt;
  String? reportVersion;
  ExecutiveSummary? executiveSummary;
  Applicant? applicant;
  IncomeDetails? incomeDetails;
  ExistingObligations? existingObligations;
  FoirAnalysis? foirAnalysis;
  EmiCapacity? emiCapacity;
  CreditBehavior? creditBehavior;
  Eligibility? eligibility;
  List<LoanScenarios>? loanScenarios;
  RiskAssessment? riskAssessment;
  Insights? insights;
  Decision? decision;

  CamReport({
    this.reportGeneratedAt,
    this.reportVersion,
    this.executiveSummary,
    this.applicant,
    this.incomeDetails,
    this.existingObligations,
    this.foirAnalysis,
    this.emiCapacity,
    this.creditBehavior,
    this.eligibility,
    this.loanScenarios,
    this.riskAssessment,
    this.insights,
    this.decision,
  });

  CamReport.fromJson(Map<String, dynamic> json) {
    reportGeneratedAt = json['reportGeneratedAt'];
    reportVersion = json['reportVersion'];
    executiveSummary = json['executiveSummary'] != null
        ? ExecutiveSummary.fromJson(json['executiveSummary'])
        : null;
    applicant = json['applicant'] != null
        ? Applicant.fromJson(json['applicant'])
        : null;
    incomeDetails = json['incomeDetails'] != null
        ? IncomeDetails.fromJson(json['incomeDetails'])
        : null;
    existingObligations = json['existingObligations'] != null
        ? ExistingObligations.fromJson(json['existingObligations'])
        : null;
    foirAnalysis = json['foirAnalysis'] != null
        ? FoirAnalysis.fromJson(json['foirAnalysis'])
        : null;
    emiCapacity = json['emiCapacity'] != null
        ? EmiCapacity.fromJson(json['emiCapacity'])
        : null;
    creditBehavior = json['creditBehavior'] != null
        ? CreditBehavior.fromJson(json['creditBehavior'])
        : null;
    eligibility = json['eligibility'] != null
        ? Eligibility.fromJson(json['eligibility'])
        : null;
    if (json['loanScenarios'] != null) {
      loanScenarios = <LoanScenarios>[];
      json['loanScenarios'].forEach((v) {
        loanScenarios!.add(LoanScenarios.fromJson(v));
      });
    }
    riskAssessment = json['riskAssessment'] != null
        ? RiskAssessment.fromJson(json['riskAssessment'])
        : null;
    insights = json['insights'] != null
        ? Insights.fromJson(json['insights'])
        : null;
    decision = json['decision'] != null
        ? Decision.fromJson(json['decision'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reportGeneratedAt'] = reportGeneratedAt;
    data['reportVersion'] = reportVersion;
    if (executiveSummary != null) {
      data['executiveSummary'] = executiveSummary!.toJson();
    }
    if (applicant != null) {
      data['applicant'] = applicant!.toJson();
    }
    if (incomeDetails != null) {
      data['incomeDetails'] = incomeDetails!;
    }
    if (existingObligations != null) {
      data['existingObligations'] = existingObligations!.toJson();
    }
    if (foirAnalysis != null) {
      data['foirAnalysis'] = foirAnalysis!.toJson();
    }
    if (emiCapacity != null) {
      data['emiCapacity'] = emiCapacity!.toJson();
    }
    if (creditBehavior != null) {
      data['creditBehavior'] = creditBehavior!.toJson();
    }
    if (eligibility != null) {
      data['eligibility'] = eligibility!.toJson();
    }
    if (loanScenarios != null) {
      data['loanScenarios'] = loanScenarios!.map((v) => v.toJson()).toList();
    }
    if (riskAssessment != null) {
      data['riskAssessment'] = riskAssessment!.toJson();
    }
    if (insights != null) {
      data['insights'] = insights!.toJson();
    }
    if (decision != null) {
      data['decision'] = decision!.toJson();
    }
    return data;
  }
}

class ExecutiveSummary {
  String? applicantName;
  int? creditScore;
  String? approvalStatus;
  String? approvalConfidence;
  int? maxLoanEligible;
  int? recommendedLoanAmount;
  String? riskLevel;
  String? keyHighlight;

  ExecutiveSummary({
    this.applicantName,
    this.creditScore,
    this.approvalStatus,
    this.approvalConfidence,
    this.maxLoanEligible,
    this.recommendedLoanAmount,
    this.riskLevel,
    this.keyHighlight,
  });

  ExecutiveSummary.fromJson(Map<String, dynamic> json) {
    applicantName = json['applicantName'];
    creditScore = json['creditScore'];
    approvalStatus = json['approvalStatus'];
    approvalConfidence = json['approvalConfidence'];
    maxLoanEligible = json['maxLoanEligible'];
    recommendedLoanAmount = json['recommendedLoanAmount'];
    riskLevel = json['riskLevel'];
    keyHighlight = json['keyHighlight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applicantName'] = applicantName;
    data['creditScore'] = creditScore;
    data['approvalStatus'] = approvalStatus;
    data['approvalConfidence'] = approvalConfidence;
    data['maxLoanEligible'] = maxLoanEligible;
    data['recommendedLoanAmount'] = recommendedLoanAmount;
    data['riskLevel'] = riskLevel;
    data['keyHighlight'] = keyHighlight;
    return data;
  }
}

class Applicant {
  String? name;
  String? pan;
  int? creditScore;
  String? creditScoreDate;
  String? creditScoreCategory;
  String? creditHistoryAge;
  int? creditHistoryMonths;
  int? totalActiveAccounts;
  AccountMix? accountMix;

  Applicant({
    this.name,
    this.pan,
    this.creditScore,
    this.creditScoreDate,
    this.creditScoreCategory,
    this.creditHistoryAge,
    this.creditHistoryMonths,
    this.totalActiveAccounts,
    this.accountMix,
  });

  Applicant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pan = json['pan'];
    creditScore = json['creditScore'];
    creditScoreDate = json['creditScoreDate'];
    creditScoreCategory = json['creditScoreCategory'];
    creditHistoryAge = json['creditHistoryAge'];
    creditHistoryMonths = json['creditHistoryMonths'];
    totalActiveAccounts = json['totalActiveAccounts'];
    accountMix = json['accountMix'] != null
        ? AccountMix.fromJson(json['accountMix'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pan'] = pan;
    data['creditScore'] = creditScore;
    data['creditScoreDate'] = creditScoreDate;
    data['creditScoreCategory'] = creditScoreCategory;
    data['creditHistoryAge'] = creditHistoryAge;
    data['creditHistoryMonths'] = creditHistoryMonths;
    data['totalActiveAccounts'] = totalActiveAccounts;
    if (accountMix != null) {
      data['accountMix'] = accountMix!.toJson();
    }
    return data;
  }
}

class AccountMix {
  int? score;
  String? label;
  List<String>? accountTypes;

  AccountMix({this.score, this.label, this.accountTypes});

  AccountMix.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    label = json['label'];
    accountTypes = json['accountTypes']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['label'] = label;
    data['accountTypes'] = accountTypes;
    return data;
  }
}

class IncomeDetails {
  int? monthlyIncome;
  String? employmentType;
  String? stabilityScore;
  int? monthlyDisposableIncome;
  int? disposableIncomePercentage;

  IncomeDetails.fromJson(Map<String, dynamic> json) {
    monthlyIncome = parseInt(json['monthlyIncome']);
    employmentType = json['employmentType'];
    stabilityScore = json['stabilityScore'];
    monthlyDisposableIncome = parseInt(json['monthlyDisposableIncome']);
    disposableIncomePercentage = parseInt(json['disposableIncomePercentage']);
  }
}

class ExistingObligations {
  int? totalMonthlyObligation;
  int? cibilBasedObligation;
  Breakdown? breakdown;

  ExistingObligations({
    this.totalMonthlyObligation,
    this.cibilBasedObligation,
    this.breakdown,
  });

  ExistingObligations.fromJson(Map<String, dynamic> json) {
    totalMonthlyObligation = json['totalMonthlyObligation'];
    cibilBasedObligation = json['cibilBasedObligation'];
    breakdown = json['breakdown'] != null
        ? Breakdown.fromJson(json['breakdown'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalMonthlyObligation'] = totalMonthlyObligation;
    data['cibilBasedObligation'] = cibilBasedObligation;
    if (breakdown != null) {
      data['breakdown'] = breakdown!.toJson();
    }
    return data;
  }
}

class Breakdown {
  CreditCards? creditCards;
  TermLoans? termLoans;
  ReportOtherObligations? otherObligations; // Renamed to avoid conflict

  Breakdown({this.creditCards, this.termLoans, this.otherObligations});

  Breakdown.fromJson(Map<String, dynamic> json) {
    creditCards = json['creditCards'] != null
        ? CreditCards.fromJson(json['creditCards'])
        : null;
    termLoans = json['termLoans'] != null
        ? TermLoans.fromJson(json['termLoans'])
        : null;
    otherObligations = json['otherObligations'] != null
        ? ReportOtherObligations.fromJson(json['otherObligations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (creditCards != null) {
      data['creditCards'] = creditCards!.toJson();
    }
    if (termLoans != null) {
      data['termLoans'] = termLoans!.toJson();
    }
    if (otherObligations != null) {
      data['otherObligations'] = otherObligations!.toJson();
    }
    return data;
  }
}

class CreditCards {
  int? count;
  int? totalMinimumPayment;
  List<dynamic>? accounts; // Changed from List<Null> to List<dynamic>

  CreditCards({this.count, this.totalMinimumPayment, this.accounts});

  CreditCards.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalMinimumPayment = json['totalMinimumPayment'];
    if (json['accounts'] != null) {
      accounts = json['accounts'] as List<dynamic>;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['totalMinimumPayment'] = totalMinimumPayment;
    if (accounts != null) {
      data['accounts'] = accounts;
    }
    return data;
  }
}

class TermLoans {
  int? count;
  int? totalEMI;
  List<Accounts>? accounts;

  TermLoans({this.count, this.totalEMI, this.accounts});

  TermLoans.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalEMI = json['totalEMI'];
    if (json['accounts'] != null) {
      accounts = <Accounts>[];
      json['accounts'].forEach((v) {
        accounts!.add(Accounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['totalEMI'] = totalEMI;
    if (accounts != null) {
      data['accounts'] = accounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Accounts {
  String? type;
  String? lender;
  String? accountNumber;
  int? outstandingBalance;
  int? monthlyEMI;
  int? repaymentTenure;
  int? paidTenure;
  int? remainingTenure;
  int? remainingAmount;
  int? paidPercentage;
  int? highCreditAmount;
  String? dateOpened;

  Accounts({
    this.type,
    this.lender,
    this.accountNumber,
    this.outstandingBalance,
    this.monthlyEMI,
    this.repaymentTenure,
    this.paidTenure,
    this.remainingTenure,
    this.remainingAmount,
    this.paidPercentage,
    this.highCreditAmount,
    this.dateOpened,
  });

  Accounts.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    lender = json['lender'];
    accountNumber = json['accountNumber'];
    outstandingBalance = json['outstandingBalance'];
    monthlyEMI = json['monthlyEMI'];
    repaymentTenure = json['repaymentTenure'];
    paidTenure = json['paidTenure'];
    remainingTenure = json['remainingTenure'];
    remainingAmount = json['remainingAmount'];
    paidPercentage = json['paidPercentage'];
    highCreditAmount = json['highCreditAmount'];
    dateOpened = json['dateOpened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['lender'] = lender;
    data['accountNumber'] = accountNumber;
    data['outstandingBalance'] = outstandingBalance;
    data['monthlyEMI'] = monthlyEMI;
    data['repaymentTenure'] = repaymentTenure;
    data['paidTenure'] = paidTenure;
    data['remainingTenure'] = remainingTenure;
    data['remainingAmount'] = remainingAmount;
    data['paidPercentage'] = paidPercentage;
    data['highCreditAmount'] = highCreditAmount;
    data['dateOpened'] = dateOpened;
    return data;
  }
}

// Renamed to avoid conflict with InputOtherObligations
class ReportOtherObligations {
  bool? declared;
  int? amount;
  dynamic note; // Changed from Null? to dynamic

  ReportOtherObligations({this.declared, this.amount, this.note});

  ReportOtherObligations.fromJson(Map<String, dynamic> json) {
    declared = json['declared'];
    amount = json['amount'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['declared'] = declared;
    data['amount'] = amount;
    data['note'] = note;
    return data;
  }
}

class FoirAnalysis {
  double? currentFOIR;
  int? currentFOIRPercentage;
  double? maxAllowedFOIR;
  double? idealFOIR;
  String? status;
  int? availableCapacity;
  String? interpretation;

  FoirAnalysis({
    this.currentFOIR,
    this.currentFOIRPercentage,
    this.maxAllowedFOIR,
    this.idealFOIR,
    this.status,
    this.availableCapacity,
    this.interpretation,
  });

  FoirAnalysis.fromJson(Map<String, dynamic> json) {
    currentFOIR = json['currentFOIR']?.toDouble();
    currentFOIRPercentage = json['currentFOIRPercentage'];
    maxAllowedFOIR = json['maxAllowedFOIR']?.toDouble();
    idealFOIR = json['idealFOIR']?.toDouble();
    status = json['status'];
    availableCapacity = json['availableCapacity'];
    interpretation = json['interpretation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentFOIR'] = currentFOIR;
    data['currentFOIRPercentage'] = currentFOIRPercentage;
    data['maxAllowedFOIR'] = maxAllowedFOIR;
    data['idealFOIR'] = idealFOIR;
    data['status'] = status;
    data['availableCapacity'] = availableCapacity;
    data['interpretation'] = interpretation;
    return data;
  }
}

class EmiCapacity {
  int? availableEMI;
  int? maxEMICapacity;
  int? conservativeEMI;
  int? recommendedEMI;
  int? emiToIncomeRatio;

  EmiCapacity({
    this.availableEMI,
    this.maxEMICapacity,
    this.conservativeEMI,
    this.recommendedEMI,
    this.emiToIncomeRatio,
  });

  EmiCapacity.fromJson(Map<String, dynamic> json) {
    availableEMI = json['availableEMI'];
    maxEMICapacity = json['maxEMICapacity'];
    conservativeEMI = json['conservativeEMI'];
    recommendedEMI = json['recommendedEMI'];
    emiToIncomeRatio = json['emiToIncomeRatio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['availableEMI'] = availableEMI;
    data['maxEMICapacity'] = maxEMICapacity;
    data['conservativeEMI'] = conservativeEMI;
    data['recommendedEMI'] = recommendedEMI;
    data['emiToIncomeRatio'] = emiToIncomeRatio;
    return data;
  }
}

class CreditBehavior {
  int? score;
  String? scoreCategory;
  PaymentHistory? paymentHistory;
  PaymentHistory? creditUtilization;
  RecentEnquiries? recentEnquiries;
  AccountMix? creditMix;
  AccountSummary? accountSummary;

  CreditBehavior({
    this.score,
    this.scoreCategory,
    this.paymentHistory,
    this.creditUtilization,
    this.recentEnquiries,
    this.creditMix,
    this.accountSummary,
  });

  CreditBehavior.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    scoreCategory = json['scoreCategory'];
    paymentHistory = json['paymentHistory'] != null
        ? PaymentHistory.fromJson(json['paymentHistory'])
        : null;
    creditUtilization = json['creditUtilization'] != null
        ? PaymentHistory.fromJson(json['creditUtilization'])
        : null;
    recentEnquiries = json['recentEnquiries'] != null
        ? RecentEnquiries.fromJson(json['recentEnquiries'])
        : null;
    creditMix = json['creditMix'] != null
        ? AccountMix.fromJson(json['creditMix'])
        : null;
    accountSummary = json['accountSummary'] != null
        ? AccountSummary.fromJson(json['accountSummary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['scoreCategory'] = scoreCategory;
    if (paymentHistory != null) {
      data['paymentHistory'] = paymentHistory!.toJson();
    }
    if (creditUtilization != null) {
      data['creditUtilization'] = creditUtilization!.toJson();
    }
    if (recentEnquiries != null) {
      data['recentEnquiries'] = recentEnquiries!.toJson();
    }
    if (creditMix != null) {
      data['creditMix'] = creditMix!.toJson();
    }
    if (accountSummary != null) {
      data['accountSummary'] = accountSummary!.toJson();
    }
    return data;
  }
}

class PaymentHistory {
  String? overallStatus;
  RecentPerformance? recentPerformance;
  int? totalLifetimeDelays;
  bool? hasWriteOff;
  bool? hasSettlement;
  String? delayTrend;
  String? interpretation;

  PaymentHistory({
    this.overallStatus,
    this.recentPerformance,
    this.totalLifetimeDelays,
    this.hasWriteOff,
    this.hasSettlement,
    this.delayTrend,
    this.interpretation,
  });

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    overallStatus = json['overallStatus'];
    recentPerformance = json['recentPerformance'] != null
        ? RecentPerformance.fromJson(json['recentPerformance'])
        : null;
    totalLifetimeDelays = json['totalLifetimeDelays'];
    hasWriteOff = json['hasWriteOff'];
    hasSettlement = json['hasSettlement'];
    delayTrend = json['delayTrend'];
    interpretation = json['interpretation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['overallStatus'] = overallStatus;
    if (recentPerformance != null) {
      data['recentPerformance'] = recentPerformance!.toJson();
    }
    data['totalLifetimeDelays'] = totalLifetimeDelays;
    data['hasWriteOff'] = hasWriteOff;
    data['hasSettlement'] = hasSettlement;
    data['delayTrend'] = delayTrend;
    data['interpretation'] = interpretation;
    return data;
  }
}

class RecentPerformance {
  int? consecutiveOnTimeMonths;
  Last12MonthsHistory? last12Months; // Renamed for clarity
  Last24Months? last24Months;

  RecentPerformance({
    this.consecutiveOnTimeMonths,
    this.last12Months,
    this.last24Months,
  });

  RecentPerformance.fromJson(Map<String, dynamic> json) {
    consecutiveOnTimeMonths = json['consecutiveOnTimeMonths'];
    last12Months = json['last12Months'] != null
        ? Last12MonthsHistory.fromJson(json['last12Months'])
        : null;
    last24Months = json['last24Months'] != null
        ? Last24Months.fromJson(json['last24Months'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['consecutiveOnTimeMonths'] = consecutiveOnTimeMonths;
    if (last12Months != null) {
      data['last12Months'] = last12Months!.toJson();
    }
    if (last24Months != null) {
      data['last24Months'] = last24Months!.toJson();
    }
    return data;
  }
}

class Last12MonthsHistory {
  int? delays30Days;
  int? delays60Days;
  int? delays90Days;
  int? delays120PlusDays;

  Last12MonthsHistory({
    this.delays30Days,
    this.delays60Days,
    this.delays90Days,
    this.delays120PlusDays,
  });

  Last12MonthsHistory.fromJson(Map<String, dynamic> json) {
    delays30Days = json['delays30Days'];
    delays60Days = json['delays60Days'];
    delays90Days = json['delays90Days'];
    delays120PlusDays = json['delays120PlusDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delays30Days'] = delays30Days;
    data['delays60Days'] = delays60Days;
    data['delays90Days'] = delays90Days;
    data['delays120PlusDays'] = delays120PlusDays;
    return data;
  }
}

class Last24Months {
  int? delays30Days;
  int? delays60Days;
  int? delays90Days;

  Last24Months({this.delays30Days, this.delays60Days, this.delays90Days});

  Last24Months.fromJson(Map<String, dynamic> json) {
    delays30Days = json['delays30Days'];
    delays60Days = json['delays60Days'];
    delays90Days = json['delays90Days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delays30Days'] = delays30Days;
    data['delays60Days'] = delays60Days;
    data['delays90Days'] = delays90Days;
    return data;
  }
}

class RecentEnquiries {
  int? last3Months;
  int? last6Months;
  int? last12Months;
  List<TopTypes>? topTypes;
  Details? details;
  String? status;
  String? interpretation;

  RecentEnquiries({
    this.last3Months,
    this.last6Months,
    this.last12Months,
    this.topTypes,
    this.details,
    this.status,
    this.interpretation,
  });

  RecentEnquiries.fromJson(Map<String, dynamic> json) {
    last3Months = json['last3Months'];
    last6Months = json['last6Months'];
    last12Months = json['last12Months'];
    if (json['topTypes'] != null) {
      topTypes = <TopTypes>[];
      json['topTypes'].forEach((v) {
        topTypes!.add(TopTypes.fromJson(v));
      });
    }
    details = json['details'] != null
        ? Details.fromJson(json['details'])
        : null;
    status = json['status'];
    interpretation = json['interpretation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last3Months'] = last3Months;
    data['last6Months'] = last6Months;
    data['last12Months'] = last12Months;
    if (topTypes != null) {
      data['topTypes'] = topTypes!.map((v) => v.toJson()).toList();
    }
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['status'] = status;
    data['interpretation'] = interpretation;
    return data;
  }
}

class TopTypes {
  String? institution;
  int? total;
  int? last3m;
  int? last6m;
  int? last12m;

  TopTypes({
    this.institution,
    this.total,
    this.last3m,
    this.last6m,
    this.last12m,
  });

  TopTypes.fromJson(Map<String, dynamic> json) {
    institution = json['institution'];
    total = json['total'];
    last3m = json['last3m'];
    last6m = json['last6m'];
    last12m = json['last12m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['institution'] = institution;
    data['total'] = total;
    data['last3m'] = last3m;
    data['last6m'] = last6m;
    data['last12m'] = last12m;
    return data;
  }
}

class Details {
  List<dynamic>? last3Months; // Changed from List<Null>
  List<EnquiryDetail>? last6Months; // Changed from List<Last6Months>
  List<dynamic>? last12Months; // Changed from List<Last12Months>

  Details({this.last3Months, this.last6Months, this.last12Months});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['last3Months'] != null) {
      last3Months = json['last3Months'] as List<dynamic>;
    }
    if (json['last6Months'] != null) {
      last6Months = <EnquiryDetail>[];
      json['last6Months'].forEach((v) {
        last6Months!.add(EnquiryDetail.fromJson(v));
      });
    }
    if (json['last12Months'] != null) {
      last12Months = json['last12Months'] as List<dynamic>;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (last3Months != null) {
      data['last3Months'] = last3Months;
    }
    if (last6Months != null) {
      data['last6Months'] = last6Months!.map((v) => v.toJson()).toList();
    }
    if (last12Months != null) {
      data['last12Months'] = last12Months;
    }
    return data;
  }
}

class EnquiryDetail {
  String? dateObj;
  String? date;
  int? daysAgo;
  String? purpose;
  String? institution;

  EnquiryDetail({
    this.dateObj,
    this.date,
    this.daysAgo,
    this.purpose,
    this.institution,
  });

  EnquiryDetail.fromJson(Map<String, dynamic> json) {
    dateObj = json['dateObj'];
    date = json['date'];
    daysAgo = json['daysAgo'];
    purpose = json['purpose'];
    institution = json['institution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateObj'] = dateObj;
    data['date'] = date;
    data['daysAgo'] = daysAgo;
    data['purpose'] = purpose;
    data['institution'] = institution;
    return data;
  }
}

class AccountSummary {
  int? totalAccounts;
  int? activeAccounts;
  int? closedAccounts;
  String? oldestAccountAge;

  AccountSummary({
    this.totalAccounts,
    this.activeAccounts,
    this.closedAccounts,
    this.oldestAccountAge,
  });

  AccountSummary.fromJson(Map<String, dynamic> json) {
    totalAccounts = json['totalAccounts'];
    activeAccounts = json['activeAccounts'];
    closedAccounts = json['closedAccounts'];
    oldestAccountAge = json['oldestAccountAge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalAccounts'] = totalAccounts;
    data['activeAccounts'] = activeAccounts;
    data['closedAccounts'] = closedAccounts;
    data['oldestAccountAge'] = oldestAccountAge;
    return data;
  }
}

class Eligibility {
  bool? passed;
  List<dynamic>? criticalIssues; // Changed from List<Null>
  List<dynamic>? warnings; // Changed from List<Null>
  List<dynamic>? allGates; // Changed from List<Null>
  int? eligibleLoanAmount;
  int? baseEligibleAmount;
  List<dynamic>? adjustments; // Changed from List<Null>
  int? totalAdjustmentPercent;
  InterestRateBand? interestRateBand;
  int? recommendedInterestRate;
  int? recommendedTenure;
  String? interestRateJustification;

  Eligibility({
    this.passed,
    this.criticalIssues,
    this.warnings,
    this.allGates,
    this.eligibleLoanAmount,
    this.baseEligibleAmount,
    this.adjustments,
    this.totalAdjustmentPercent,
    this.interestRateBand,
    this.recommendedInterestRate,
    this.recommendedTenure,
    this.interestRateJustification,
  });

  Eligibility.fromJson(Map<String, dynamic> json) {
    passed = json['passed'];
    if (json['criticalIssues'] != null) {
      criticalIssues = json['criticalIssues'] as List<dynamic>;
    }
    if (json['warnings'] != null) {
      warnings = json['warnings'] as List<dynamic>;
    }
    if (json['allGates'] != null) {
      allGates = json['allGates'] as List<dynamic>;
    }
    eligibleLoanAmount = json['eligibleLoanAmount'];
    baseEligibleAmount = json['baseEligibleAmount'];
    if (json['adjustments'] != null) {
      adjustments = json['adjustments'] as List<dynamic>;
    }
    totalAdjustmentPercent = json['totalAdjustmentPercent'];
    interestRateBand = json['interestRateBand'] != null
        ? InterestRateBand.fromJson(json['interestRateBand'])
        : null;
    recommendedInterestRate = json['recommendedInterestRate'];
    recommendedTenure = json['recommendedTenure'];
    interestRateJustification = json['interestRateJustification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passed'] = passed;
    if (criticalIssues != null) {
      data['criticalIssues'] = criticalIssues;
    }
    if (warnings != null) {
      data['warnings'] = warnings;
    }
    if (allGates != null) {
      data['allGates'] = allGates;
    }
    data['eligibleLoanAmount'] = eligibleLoanAmount;
    data['baseEligibleAmount'] = baseEligibleAmount;
    if (adjustments != null) {
      data['adjustments'] = adjustments;
    }
    data['totalAdjustmentPercent'] = totalAdjustmentPercent;
    if (interestRateBand != null) {
      data['interestRateBand'] = interestRateBand!.toJson();
    }
    data['recommendedInterestRate'] = recommendedInterestRate;
    data['recommendedTenure'] = recommendedTenure;
    data['interestRateJustification'] = interestRateJustification;
    return data;
  }
}

class InterestRateBand {
  int? min;
  int? max;
  String? label;

  InterestRateBand({this.min, this.max, this.label});

  InterestRateBand.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['label'] = label;
    return data;
  }
}

class LoanScenarios {
  String? label;
  String? description;
  int? loanAmount;
  int? emi;
  int? tenure;
  int? interestRate;
  int? totalInterest;
  int? totalPayable;
  int? postLoanFOIR;
  int? monthlyBudgetLeft;
  String? status;
  bool? recommended;
  String? reasoning;

  LoanScenarios({
    this.label,
    this.description,
    this.loanAmount,
    this.emi,
    this.tenure,
    this.interestRate,
    this.totalInterest,
    this.totalPayable,
    this.postLoanFOIR,
    this.monthlyBudgetLeft,
    this.status,
    this.recommended,
    this.reasoning,
  });

  LoanScenarios.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    description = json['description'];
    loanAmount = json['loanAmount'];
    emi = json['emi'];
    tenure = json['tenure'];
    interestRate = json['interestRate'];
    totalInterest = json['totalInterest'];
    totalPayable = json['totalPayable'];
    postLoanFOIR = json['postLoanFOIR'];
    monthlyBudgetLeft = json['monthlyBudgetLeft'];
    status = json['status'];
    recommended = json['recommended'];
    reasoning = json['reasoning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['description'] = description;
    data['loanAmount'] = loanAmount;
    data['emi'] = emi;
    data['tenure'] = tenure;
    data['interestRate'] = interestRate;
    data['totalInterest'] = totalInterest;
    data['totalPayable'] = totalPayable;
    data['postLoanFOIR'] = postLoanFOIR;
    data['monthlyBudgetLeft'] = monthlyBudgetLeft;
    data['status'] = status;
    data['recommended'] = recommended;
    data['reasoning'] = reasoning;
    return data;
  }
}

class RiskAssessment {
  String? category;
  String? label;
  String? color;
  RiskFactors? riskFactors;
  List<String>? strengths;
  List<dynamic>? concerns; // Changed from List<Null>
  List<String>? mitigatingFactors;
  OverallRiskScore? overallRiskScore;

  RiskAssessment({
    this.category,
    this.label,
    this.color,
    this.riskFactors,
    this.strengths,
    this.concerns,
    this.mitigatingFactors,
    this.overallRiskScore,
  });

  RiskAssessment.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    label = json['label'];
    color = json['color'];
    riskFactors = json['riskFactors'] != null
        ? RiskFactors.fromJson(json['riskFactors'])
        : null;
    strengths = json['strengths']?.cast<String>();
    if (json['concerns'] != null) {
      concerns = json['concerns'] as List<dynamic>;
    }
    mitigatingFactors = json['mitigatingFactors']?.cast<String>();
    overallRiskScore = json['overallRiskScore'] != null
        ? OverallRiskScore.fromJson(json['overallRiskScore'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['label'] = label;
    data['color'] = color;
    if (riskFactors != null) {
      data['riskFactors'] = riskFactors!.toJson();
    }
    data['strengths'] = strengths;
    if (concerns != null) {
      data['concerns'] = concerns;
    }
    data['mitigatingFactors'] = mitigatingFactors;
    if (overallRiskScore != null) {
      data['overallRiskScore'] = overallRiskScore!.toJson();
    }
    return data;
  }
}

class RiskFactors {
  CreditScoreRisk? creditScore; // Renamed to avoid conflict
  PaymentHistoryRisk? paymentHistory; // Renamed to avoid conflict
  PaymentHistoryRisk? debtBurden;
  PaymentHistoryRisk? creditUtilization;
  PaymentHistoryRisk? enquiryPattern;

  RiskFactors({
    this.creditScore,
    this.paymentHistory,
    this.debtBurden,
    this.creditUtilization,
    this.enquiryPattern,
  });

  RiskFactors.fromJson(Map<String, dynamic> json) {
    creditScore = json['creditScore'] != null
        ? CreditScoreRisk.fromJson(json['creditScore'])
        : null;
    paymentHistory = json['paymentHistory'] != null
        ? PaymentHistoryRisk.fromJson(json['paymentHistory'])
        : null;
    debtBurden = json['debtBurden'] != null
        ? PaymentHistoryRisk.fromJson(json['debtBurden'])
        : null;
    creditUtilization = json['creditUtilization'] != null
        ? PaymentHistoryRisk.fromJson(json['creditUtilization'])
        : null;
    enquiryPattern = json['enquiryPattern'] != null
        ? PaymentHistoryRisk.fromJson(json['enquiryPattern'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (creditScore != null) {
      data['creditScore'] = creditScore!.toJson();
    }
    if (paymentHistory != null) {
      data['paymentHistory'] = paymentHistory!.toJson();
    }
    if (debtBurden != null) {
      data['debtBurden'] = debtBurden!.toJson();
    }
    if (creditUtilization != null) {
      data['creditUtilization'] = creditUtilization!.toJson();
    }
    if (enquiryPattern != null) {
      data['enquiryPattern'] = enquiryPattern!.toJson();
    }
    return data;
  }
}

class CreditScoreRisk {
  int? value;
  String? risk;
  String? weight;

  CreditScoreRisk({this.value, this.risk, this.weight});

  CreditScoreRisk.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    risk = json['risk'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['risk'] = risk;
    data['weight'] = weight;
    return data;
  }
}

class PaymentHistoryRisk {
  String? value;
  String? risk;
  String? weight;

  PaymentHistoryRisk({this.value, this.risk, this.weight});

  PaymentHistoryRisk.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    risk = json['risk'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['risk'] = risk;
    data['weight'] = weight;
    return data;
  }
}

class OverallRiskScore {
  int? score;
  int? maxScore;
  int? percentage;
  String? grade;

  OverallRiskScore({this.score, this.maxScore, this.percentage, this.grade});

  OverallRiskScore.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    maxScore = json['maxScore'];
    percentage = json['percentage'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['maxScore'] = maxScore;
    data['percentage'] = percentage;
    data['grade'] = grade;
    return data;
  }
}

class Insights {
  List<WhatIsGood>? whatIsGood;
  List<dynamic>? whatNeedsAttention; // Changed from List<Null>
  List<dynamic>? improvementSuggestions; // Changed from List<Null>

  Insights({
    this.whatIsGood,
    this.whatNeedsAttention,
    this.improvementSuggestions,
  });

  Insights.fromJson(Map<String, dynamic> json) {
    if (json['whatIsGood'] != null) {
      whatIsGood = <WhatIsGood>[];
      json['whatIsGood'].forEach((v) {
        whatIsGood!.add(WhatIsGood.fromJson(v));
      });
    }
    if (json['whatNeedsAttention'] != null) {
      whatNeedsAttention = json['whatNeedsAttention'] as List<dynamic>;
    }
    if (json['improvementSuggestions'] != null) {
      improvementSuggestions = json['improvementSuggestions'] as List<dynamic>;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (whatIsGood != null) {
      data['whatIsGood'] = whatIsGood!.map((v) => v.toJson()).toList();
    }
    if (whatNeedsAttention != null) {
      data['whatNeedsAttention'] = whatNeedsAttention;
    }
    if (improvementSuggestions != null) {
      data['improvementSuggestions'] = improvementSuggestions;
    }
    return data;
  }
}

class WhatIsGood {
  String? category;
  String? insight;
  String? impact;

  WhatIsGood({this.category, this.insight, this.impact});

  WhatIsGood.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    insight = json['insight'];
    impact = json['impact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['insight'] = insight;
    data['impact'] = impact;
    return data;
  }
}

class Decision {
  String? status;
  String? recommendation;
  String? confidence;
  List<String>? conditions;
  List<NextSteps>? nextSteps;
  List<dynamic>? specialNotes; // Changed from List<Null>

  Decision({
    this.status,
    this.recommendation,
    this.confidence,
    this.conditions,
    this.nextSteps,
    this.specialNotes,
  });

  Decision.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    recommendation = json['recommendation'];
    confidence = json['confidence'];
    conditions = json['conditions']?.cast<String>();
    if (json['nextSteps'] != null) {
      nextSteps = <NextSteps>[];
      json['nextSteps'].forEach((v) {
        nextSteps!.add(NextSteps.fromJson(v));
      });
    }
    if (json['specialNotes'] != null) {
      specialNotes = json['specialNotes'] as List<dynamic>;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['recommendation'] = recommendation;
    data['confidence'] = confidence;
    data['conditions'] = conditions;
    if (nextSteps != null) {
      data['nextSteps'] = nextSteps!.map((v) => v.toJson()).toList();
    }
    if (specialNotes != null) {
      data['specialNotes'] = specialNotes;
    }
    return data;
  }
}

class NextSteps {
  String? step;
  String? action;
  String? timeline;

  NextSteps({this.step, this.action, this.timeline});

  NextSteps.fromJson(Map<String, dynamic> json) {
    step = json['step'];
    action = json['action'];
    timeline = json['timeline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step'] = step;
    data['action'] = action;
    data['timeline'] = timeline;
    return data;
  }
}

int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}
