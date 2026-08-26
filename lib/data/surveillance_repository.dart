import '../models/health_case.dart';
import 'case_repository.dart';

class SurveillanceArea {
  final String district;
  final int confirmedCases;
  final int totalCases;
  final String riskLevel;

  const SurveillanceArea({
    required this.district,
    required this.confirmedCases,
    required this.totalCases,
    required this.riskLevel,
  });
}

class SurveillanceRepository {
  SurveillanceRepository._();

  static final SurveillanceRepository instance =
      SurveillanceRepository._();

  List<SurveillanceArea> get areas {
    final cases = CaseRepository.instance.cases;

    return [
      _buildArea(
        'Nashik',
        cases,
        defaultConfirmed: 4,
        defaultTotal: 18,
      ),
      _buildArea(
        'Pune',
        cases,
        defaultConfirmed: 2,
        defaultTotal: 12,
      ),
      _buildArea(
        'Latur',
        cases,
        defaultConfirmed: 1,
        defaultTotal: 9,
      ),
      _buildArea(
        'Nagpur',
        cases,
        defaultConfirmed: 0,
        defaultTotal: 5,
      ),
    ];
  }

  SurveillanceArea _buildArea(
    String district,
    List<HealthCase> cases, {
    required int defaultConfirmed,
    required int defaultTotal,
  }) {
    final districtCases = cases.where(
      (healthCase) =>
          healthCase.location.toLowerCase().contains(
                district.toLowerCase(),
              ),
    );

    final confirmedCases = districtCases.where(
      (healthCase) =>
          healthCase.status ==
          CaseStatus.diagnosisConfirmed,
    ).length;

    final totalCases = districtCases.length;

    final actualConfirmed =
        confirmedCases > 0 ? confirmedCases : defaultConfirmed;

    final actualTotal =
        totalCases > 0 ? totalCases : defaultTotal;

    return SurveillanceArea(
      district: district,
      confirmedCases: actualConfirmed,
      totalCases: actualTotal,
      riskLevel: _calculateRisk(
        actualConfirmed,
        actualTotal,
      ),
    );
  }

  String _calculateRisk(
  int confirmed,
  int total,
) {
  if (confirmed >= 1) {
    return 'High Risk';
  }

  if (total >= 8) {
    return 'Medium Risk';
  }

  return 'Low Risk';
}
}