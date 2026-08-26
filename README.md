# MahaPashu Suraksha — Flutter Prototype

A mobile frontend prototype for a Maharashtra livestock disease surveillance and early-warning platform.

## Run

1. Install Flutter and Android Studio.
2. Open this folder in Android Studio.
3. Run:
   flutter pub get
   flutter run

## Prototype behavior

The app contains role-based views for:
- Farmer
- Veterinarian
- Laboratory
- Government Officer

The demo workflow is intentionally synthetic:
Farmer voice-report UI → case → simulated AI triage → vet review → sample → lab result → confirmed disease → outbreak signal → government dashboard/alerts.

## Next integration

Replace the simulated voice button with:
Flutter recording → your backend → Sarvam AI STT → Marathi transcript.

Do not put the Sarvam API key in the Flutter app. Keep it on a backend.
