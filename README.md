# SoberOne — Sobriety & Habit Recovery Mobile App

A modern, empathetic, and science-backed sobriety tracker and habit recovery Flutter mobile application frontend.

---

## 🌟 Key Features

### 1. ⏱️ Real-Time Sobriety Clock
- Live real-time counter ticking every second (Days, Hours, Minutes, Seconds).
- Clean, focused display with custom target habit indicators (e.g., *Free from Alcohol*, *Free from Smoking*, *Gambling*, etc.).
- Compounding freedom metrics: **Money Saved** ($) and **Hours Reclaimed** based on custom daily parameters.

### 2. 🛡️ Craving SOS Emergency Toolkit
- **Interactive 4-7-8 Breathing Circle**: Live animated pacing circle (Inhale 4s ➔ Hold 7s ➔ Exhale 8s) to downregulate cortisol and soothe the nervous system.
- **5-4-3-2-1 Sensory Grounding Guide**: Step-by-step cognitive exercise to anchor attention during intense craving surges.
- **24/7 Crisis Helplines**: Instant access to SAMHSA, 988 Suicide & Crisis Lifeline, and Crisis Text Line.

### 3. 📝 Daily Check-In & Craving Journal
- **Emotional Baseline (Mood)**: 5 expressive states (Great, Good, Neutral, Low, Struggling).
- **Craving Intensity Slider**: Interactive 1–10 scale with dynamic feedback.
- **Trigger Tagging**: Multi-select tags (Stress, Social Gatherings, Boredom, Fatigue, Loneliness, Anger, Celebration, Routine).
- **Reflective Journaling & Gratitude**: Daily prompts to foster positive neuroplasticity.

### 4. 📊 Recovery Analytics & Biological Timeline
- **Craving Trend Graph**: 7-day visual line chart powered by `fl_chart`.
- **Top Triggers Breakdown**: Frequency analysis of personal craving triggers.
- **Biomedical Recovery Timeline**: Real-time progress bars for biological recovery stages (Cardiovascular normalization at 8h, Detoxification at 24h, Sensory rejuvenation at 48h, Sleep architecture at 7d, Liver repair at 30d, Dopamine baseline at 90d).

### 5. 🏆 Milestone Badges & Achievements
- Milestone gallery with locked/unlocked statuses, percentage progress, and descriptions (24 Hours, 3 Days, 1 Week, 14 Days, 1 Month, 60 Days, 90 Days, 6 Months, 1 Year).

### 6. 🤝 Fellowship & Recovery Stories
- Peer support feed with cheer interactions and story sharing.
- Safe, anonymous community space.

### 7. ⚙️ Profile & Compassionate Relapse Handling
- Flexible quit date & time adjustments.
- Daily financial and time savings calculator customization.
- **Guilt-free Streak Reset**: Compassionate coaching modal reinforcing that slips are data and learning, not failure.
- Local data persistence with `shared_preferences`.

---

## 🏗️ Architecture

```
lib/
├── main.dart                          # App entry point, MultiProvider configuration
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Habits, triggers, hotline data
│   ├── theme/
│   │   ├── app_colors.dart            # Midnight slate, emerald, amber palette
│   │   └── app_theme.dart             # Dark & light Material 3 design system
│   └── utils/
│       ├── encouragement_quotes.dart  # Inspirational recovery quote repository
│       └── time_formatter.dart        # Real-time clock breakdown & formatting
├── models/
│   ├── check_in.dart                  # Mood, cravings, triggers, gratitude models
│   ├── community_post.dart            # Peer support post model
│   ├── health_milestone.dart          # Biological recovery milestone definitions
│   ├── milestone.dart                 # Achievement badges & criteria
│   └── sobriety_profile.dart          # User settings, elapsed time & savings math
├── providers/
│   ├── check_in_provider.dart         # Check-in history & analytics state
│   ├── community_provider.dart        # Peer stories & cheers state
│   └── sobriety_provider.dart         # Live 1-second ticker, dates, persistent storage
└── screens/
    ├── main_navigation_screen.dart    # Bottom navigation bar with 5 primary destinations
    ├── analytics/
    │   └── analytics_screen.dart      # Trends chart, trigger chips, health timeline
    ├── community/
    │   └── community_screen.dart      # Fellowship feed & new post sheet
    ├── home/
    │   ├── home_screen.dart           # Dashboard with ticker, pledge, next milestone
    │   └── widgets/
    │       ├── counter_card.dart      # Glowing live clock
    │       ├── daily_pledge_card.dart # Daily commitment toggle
    │       ├── next_milestone_card.dart # Next badge progress bar
    │       ├── quote_card.dart        # Reflection card
    │       └── savings_card.dart      # Financial & time savings
    ├── milestones/
    │   └── milestones_screen.dart     # Trophy showcase
    ├── profile/
    │   └── profile_screen.dart        # Settings, quit date picker & reset streak
    ├── tracker/
    │   └── check_in_screen.dart       # Mood, craving slider, triggers & notes
    └── widgets/
        └── sos_panic_dialog.dart      # 4-7-8 breathing circle & grounding toolkit
```

---

## 🚀 Running the App

### Requirements
- Flutter SDK 3.19+ (Dart 3.3+)
- Windows, Chrome, iOS Simulator, or Android Emulator

### Commands
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run static analysis
flutter analyze

# 3. Run unit & widget tests
flutter test

# 4. Launch on your preferred device (e.g. Chrome, Windows, or connected phone)
flutter run -d chrome
# or
flutter run -d windows
```

# SoberoneMVP

