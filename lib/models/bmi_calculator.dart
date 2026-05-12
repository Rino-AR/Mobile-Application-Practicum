/// Enum-style constants for BMI measurement standards.
class BmiStandard {
  const BmiStandard._();

  static const String international = 'international';
  static const String american = 'american';
}

/// Encapsulates BMI calculation logic for both International (metric)
/// and American (imperial) standards.
///
/// International: weight in kg, height in cm → BMI = kg / m²
/// American:      weight in lbs, height in total inches → BMI = 703 × lbs / in²
class BmiCalculator {
  /// Weight in kg (metric) or lbs (imperial).
  final double weight;

  /// Height in cm (metric) or total inches (imperial).
  final double height;

  /// One of [BmiStandard.international] or [BmiStandard.american].
  final String standard;

  const BmiCalculator({
    required this.weight,
    required this.height,
    required this.standard,
  });

  bool get isMetric => standard == BmiStandard.international;

  /// Calculated BMI value.
  double get bmi {
    if (isMetric) {
      final heightM = height / 100.0;
      return weight / (heightM * heightM);
    } else {
      // American standard formula: 703 × lbs / inches²
      return (703.0 * weight) / (height * height);
    }
  }

  /// WHO / CDC category label (same thresholds for both standards).
  String get category {
    final b = bmi;
    if (b < 18.5) return 'Kurus';
    if (b < 25.0) return 'Normal';
    if (b < 30.0) return 'Overweight';
    return 'Obesitas';
  }

  /// Personalised health advice based on BMI category.
  String get advice {
    switch (category) {
      case 'Kurus':
        return 'Berat badan Anda di bawah normal. Tingkatkan asupan makanan bergizi '
            'dan konsultasikan pola makan dengan ahli gizi.';
      case 'Normal':
        return 'Selamat! Berat badan Anda ideal. Pertahankan pola makan seimbang '
            'dan olahraga rutin untuk menjaga kondisi ini.';
      case 'Overweight':
        return 'Berat badan sedikit berlebih. Coba tambah aktivitas fisik minimal '
            '30 menit per hari dan perhatikan asupan kalori harian.';
      default:
        return 'Berat badan Anda melebihi batas sehat. Sangat disarankan untuk '
            'berkonsultasi dengan dokter atau ahli gizi.';
    }
  }

  /// Formats height for display depending on the standard.
  ///
  /// Metric: returns "165 cm"
  /// Imperial: converts total inches to ft & in, e.g. "5' 5\""
  String get heightDisplay {
    if (isMetric) {
      return '${height.toInt()} cm';
    }
    final ft = height.toInt() ~/ 12;
    final inches = height.toInt() % 12;
    return "$ft' $inches\"";
  }

  /// Formats weight for display depending on the standard.
  String get weightDisplay {
    if (isMetric) {
      return '${weight.toInt()} kg';
    }
    return '${weight.toInt()} lbs';
  }
}
