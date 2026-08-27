import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/theme/app_theme.dart';
import '../../models/animal.dart';
import '../../models/health_case.dart';
import '../../data/case_repository.dart';
import '../../services/symptom_analyzer.dart';
import '../../services/ai_triage_service.dart';


class ReportHealthScreen extends StatefulWidget {
  final Animal animal;
  

  const ReportHealthScreen({
    super.key,
    required this.animal,
  });

  @override
  State<ReportHealthScreen> createState() =>
      _ReportHealthScreenState();
}

class _ReportHealthScreenState extends State<ReportHealthScreen> {
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final stt.SpeechToText speech = stt.SpeechToText();

    bool isListening = false;
    bool speechAvailable = false;

    String selectedLanguage = 'en_IN';

  final List<String> availableSymptoms = [
    'Fever',
    'Reduced appetite',
    'Excessive salivation',
    'Coughing',
    'Nasal discharge',
    'Difficulty walking',
    'Skin lesions',
    'Swelling',
    'Diarrhea',
    'Vomiting',
    'Reduced milk production',
    'Abnormal behavior',
  ];

  final Set<String> selectedSymptoms = {};

  CaseSeverity severity = CaseSeverity.moderate;

  Future<void> _initializeSpeech() async {
  speechAvailable = await speech.initialize(
    onStatus: (status) {
      if (!mounted) {
        return;
      }

      setState(() {
        isListening = status == 'listening';
      });
    },
    onError: (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isListening = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Speech recognition error: ${error.errorMsg}',
          ),
        ),
      );
    },
  );

  if (mounted) {
    setState(() {});
  }
}

Future<void> _toggleListening() async {
  if (!speechAvailable) {
    await _initializeSpeech();
  }

  if (!speechAvailable) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Speech recognition is not available on this device.',
        ),
      ),
    );

    return;
  }

  if (isListening) {
    await speech.stop();

    if (mounted) {
      setState(() {
        isListening = false;
      });
    }

    return;
  }

  await speech.listen(
    localeId: selectedLanguage,
    listenMode: stt.ListenMode.dictation,
    partialResults: true,
    onResult: (result) {
      if (!mounted) {
        return;
      }

      setState(() {
        descriptionController.text = result.recognizedWords;
        descriptionController.selection =
            TextSelection.fromPosition(
          TextPosition(
            offset: descriptionController.text.length,
          ),
        );
      });
    },
  );

  if (mounted) {
    setState(() {
      isListening = true;
    });
  }
}



  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report Health Issue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            _animalCard(),

            const SizedBox(height: 22),

            const Text(
              'What symptoms are you seeing?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Select all symptoms that apply.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 14),

            _symptoms(),

            const SizedBox(height: 22),

            const Text(
              'Severity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _severitySelector(),

            const SizedBox(height: 22),

            const Text(
              'Describe the problem',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _languageSelector(),

const SizedBox(height: 10),

TextFormField(
  controller: descriptionController,
  maxLines: 5,
  decoration: InputDecoration(
    hintText:
        'Describe when the symptoms started and anything unusual you have noticed...',
    alignLabelWithHint: true,
    suffixIcon: IconButton(
      onPressed: _toggleListening,
      tooltip: isListening
          ? 'Stop listening'
          : 'Speak',
      icon: Icon(
        isListening
            ? Icons.stop_circle_outlined
            : Icons.mic_none_outlined,
        color: isListening
            ? Colors.red
            : AppTheme.primary,
      ),
    ),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please describe the problem';
    }

    return null;
  },
),

            const SizedBox(height: 28),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(
                  Icons.send_outlined,
                ),
                label: const Text(
                  'Submit Health Report',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Your report will be sent to a veterinarian for assessment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.pets,
              color: AppTheme.primary,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reporting for',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.animal.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${widget.animal.breed} • ${widget.animal.id}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _symptoms() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableSymptoms.map(
        (symptom) {
          final selected = selectedSymptoms.contains(symptom);

          return FilterChip(
            label: Text(
              symptom,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
            selected: selected,
            selectedColor: AppTheme.primary,
            checkmarkColor: Colors.white,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected
                  ? AppTheme.primary
                  : Colors.black.withValues(alpha: 0.08),
            ),
            onSelected: (value) {
              setState(() {
                if (value) {
                  selectedSymptoms.add(symptom);
                } else {
                  selectedSymptoms.remove(symptom);
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget _severitySelector() {
    return Row(
      children: [
        _severityButton(
          CaseSeverity.low,
          'Low',
          Colors.green,
        ),
        const SizedBox(width: 8),
        _severityButton(
          CaseSeverity.moderate,
          'Moderate',
          Colors.orange,
        ),
        const SizedBox(width: 8),
        _severityButton(
          CaseSeverity.high,
          'High',
          Colors.red,
        ),
        const SizedBox(width: 8),
        _severityButton(
          CaseSeverity.critical,
          'Critical',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _severityButton(
    CaseSeverity value,
    String label,
    Color color,
  ) {
    final selected = severity == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            severity = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected
                ? color
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(
                alpha: selected ? 1 : 0.18,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageSelector() {
  return DropdownButtonFormField<String>(
    initialValue: selectedLanguage,
    decoration: const InputDecoration(
      labelText: 'Voice language',
      prefixIcon: Icon(
        Icons.language_outlined,
      ),
    ),
    items: const [
      DropdownMenuItem(
        value: 'en_IN',
        child: Text('English'),
      ),
      DropdownMenuItem(
        value: 'hi_IN',
        child: Text('Hindi'),
      ),
      DropdownMenuItem(
        value: 'mr_IN',
        child: Text('Marathi'),
      ),
    ],
    onChanged: (value) {
      if (value == null) {
        return;
      }

      setState(() {
        selectedLanguage = value;
      });
    },
  );
}

  void _submit() {
  if (!formKey.currentState!.validate()) {
    return;
  }

  if (selectedSymptoms.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select at least one symptom.',
        ),
      ),
    );
    return;
  }

  final description = descriptionController.text.trim();

  // Analyze the farmer's description.
  final analysis = SymptomAnalyzer.analyze(description);

  // Combine manually selected symptoms with symptoms
  // detected from the description.
  final allSymptoms = {
    ...selectedSymptoms,
    ...analysis.detectedSymptoms,
  }.toList();

  final newCaseId =
    'CASE-MH-NK-${DateTime.now().millisecondsSinceEpoch % 100000}';

final initialCase = HealthCase(
  id: newCaseId,
  animal: widget.animal,
  symptoms: allSymptoms,
  description: descriptionController.text.trim(),
  severity: severity,
  status: CaseStatus.reported,
  reportedDate: '26 Aug 2026',
  location: widget.animal.location,
);

// Run prototype AI triage.
final triageResult = AiTriageService.analyze(initialCase);

// Store the case together with the triage result.
final newCase = HealthCase(
  id: initialCase.id,
  animal: initialCase.animal,
  symptoms: initialCase.symptoms,
  description: initialCase.description,
  severity: initialCase.severity,
  status: initialCase.status,
  reportedDate: initialCase.reportedDate,
  location: initialCase.location,

  triageRisk: triageResult.riskLevel,
  triageDisease: triageResult.possibleDisease,
  triageRecommendation: triageResult.recommendation,
  triageUrgency: triageResult.urgency,
);

CaseRepository.instance.addCase(newCase);

Navigator.pop(context, newCase);

  
}
}