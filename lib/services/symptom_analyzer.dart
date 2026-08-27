class SymptomAnalysis {
  final List<String> detectedSymptoms;
  final List<String> matchedKeywords;

  const SymptomAnalysis({
    required this.detectedSymptoms,
    required this.matchedKeywords,
  });
}

class SymptomAnalyzer {
  static const Map<String, List<String>> _symptomKeywords = {
    'Fever': [
      'fever',
      'temperature',
      'hot',
      'ताप',
      'बुखार',
    ],
    'Reduced appetite': [
      'not eating',
      'does not eat',
      'not eating properly',
      'reduced appetite',
      'no appetite',
      'खात नाही',
      'भूक नाही',
      'खाना नहीं',
      'भूख नहीं',
    ],
    'Excessive salivation': [
      'salivation',
      'drooling',
      'drool',
      'excessive saliva',
      'लाळ',
      'लाळ येत',
      'मुंह से लार',
      'लार',
    ],
    'Coughing': [
      'cough',
      'coughing',
      'खोकला',
      'खोकत',
      'खांसी',
    ],
    'Nasal discharge': [
      'nasal discharge',
      'runny nose',
      'discharge from nose',
      'नाकातून पाणी',
      'नाक वाहत',
      'नाक बहना',
    ],
    'Difficulty walking': [
      'difficulty walking',
      'cannot walk',
      'unable to walk',
      'lameness',
      'walking problem',
      'चालत नाही',
      'चालण्यास त्रास',
      'चलने में दिक्कत',
    ],
    'Skin lesions': [
      'skin lesion',
      'skin lesions',
      'sores',
      'wounds',
      'skin wound',
      'त्वचेवर जखम',
      'जखम',
      'त्वचा पर घाव',
    ],
    'Swelling': [
      'swelling',
      'swollen',
      'सूज',
      'सूज आली',
      'सूजन',
    ],
    'Diarrhea': [
      'diarrhea',
      'diarrhoea',
      'loose motion',
      'loose stool',
      'जुलाब',
      'दस्त',
    ],
    'Vomiting': [
      'vomiting',
      'vomit',
      'उलटी',
      'उलट्या',
      'उल्टी',
    ],
    'Reduced milk production': [
      'less milk',
      'reduced milk',
      'milk production decreased',
      'milk has decreased',
      'दूध कमी',
      'दूध कमी झाले',
      'दूध कम',
    ],
    'Abnormal behavior': [
      'abnormal behavior',
      'strange behavior',
      'acting strangely',
      'unusual behavior',
      'विचित्र वर्तन',
      'असामान्य वर्तन',
      'अजीब व्यवहार',
    ],
  };

  static SymptomAnalysis analyze(String text) {
    final normalizedText = text.toLowerCase().trim();

    final detectedSymptoms = <String>[];
    final matchedKeywords = <String>[];

    for (final entry in _symptomKeywords.entries) {
      for (final keyword in entry.value) {
        if (normalizedText.contains(keyword.toLowerCase())) {
          detectedSymptoms.add(entry.key);
          matchedKeywords.add(keyword);
          break;
        }
      }
    }

    return SymptomAnalysis(
      detectedSymptoms: detectedSymptoms,
      matchedKeywords: matchedKeywords,
    );
  }
}