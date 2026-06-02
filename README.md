# Flutter AdScreen Player — Offline-First Digital Signage

A robust, high-uptime digital signage player built with Flutter. Designed for Android TV and physical display boards, featuring multi-zone rendering, background telemetry, and offline-first persistence.

---

## 🏗️ Architecture & Technical Stack

The application follows a **Decoupled Clean Architecture** with platform-specific isolation to ensure stability across Android and Web (Chrome) environments.

- **Frontend**: Flutter (3.12.0+)
- **Local Database**: [Isar NoSQL](https://isar.dev/) for high-performance offline storage.
- **Background Processing**: `flutter_background_service` for persistent Android Foreground Services.
- **Networking**: `Dio` with custom interceptors for mock/live environments and concurrent asset downloads.
- **UI Design**: 10-foot UI optimized for TVs, featuring glassmorphism and high-contrast dark mode.

---

## 🚀 Key Features

### 1. Multi-Zone Rendering Engine
Orchestrates parallel playback of video and image content across coordinate-mapped regions.
- **Absolute Positioning**: Renders zones based on normalized `(x, y, w, h)` maps from the server.
- **Independent Loops**: Each region manages its own playback queue and transitions.
- **Hybrid Source**: Automatically toggles between local cached files and network fallbacks.

### 2. Offline-First Sync & Persistence
Guarantees uninterrupted playout even during network loss.
- **Asset Manager**: Concurrent downloader with pooled worker threads (max 2 parallel).
- **Play Log Buffer**: Captures every impression locally; batch-uploads to cloud when connection is restored.
- **Automatic Housekeeping**: Clears stale cached assets to prevent storage bloat.

### 3. Diagnostics & Control Console
A professional administrative overlay (HUD) for field engineers.
- **Health Monitoring**: Real-time CPU, RAM, and motherboard temperature telemetry.
- **Sync Audit**: Live status of cached schedules and pending metric uploads.
- **Hardware Metadata**: Displays immutable device identifiers (UUID/Serial) and OS platform details.

### 4. Hardware Integration (Android Specific)
- **Persistent Service**: Runs as a sticky Foreground Service to prevent OS-level process killing.
- **Boot Start**: Native `BroadcastReceiver` launches the player automatically on device power-on.
- **Heartbeat Loop**: 60-second telemetry pulses to the central dashboard.

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── network/       # Dio client & Mock Interceptors
│   └── services/      # Background Service, Device Info, Secure Storage
├── data/
│   ├── local/         # Isar DB Manager & Metrics Buffer (Native/Web isolated)
│   └── remote/        # Asset Download Manager
├── domain/
│   └── models/        # Platform-agnostic Data Models
└── presentation/
    ├── screens/       # Splash, Provisioning, Control Console, Player
    └── widgets/       # Multi-Zone Presenter, Diagnostics HUD, Zone Frame
```

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK `^3.12.0`
- Android Studio / VS Code
- Android SDK 36 (Required for latest plugin compatibility)

### Installation
1. Clone the repository.
2. Run `flutter pub get`.
3. Generate local database schemas:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Running the App
- **For Android (Signage Mode)**:
  ```bash
  flutter run -d <android_device_id>
  ```
- **For Chrome (UI Debugging)**:
  ```bash
  flutter run -d chrome
  ```
  *Note: Web mode uses mock implementations for Isar and Background Services.*

---

## 🛡️ Security & Compliance
- **Credential Safety**: `screenToken` and `screenId` are persisted in the hardware secure enclave via `FlutterSecureStorage`.
- **Storage Isolation**: Media assets are stored in internal app directories (`getApplicationSupportDirectory`) to prevent unauthorized extraction.
- **Backoff Strategy**: Exponential backoff with jitter is implemented for all heartbeat and metrics retry logic.

---
*Developed for the AdScreen CMS Ecosystem.*
