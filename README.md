# NextBus 🚌

A beautiful, modern Flutter application designed to interact with Vancouver TransLink's SMS Next Bus system.

## 🌟 Purpose

The primary purpose of **NextBus** is to provide a sleek, user-friendly interface for fetching live bus arrival times using the official **TransLink SMS system (33333)**. This is helpful for those who don't have a data connection or prefer to use SMS for quick lookups. By simply entering your Stop ID and Bus Number, the app is designed to fetch your incoming transit schedules and present them beautifully.

## ✨ Features

- **TransLink Brand Theme**: Immersive UI using the official Vancouver TransLink colors:
  - Endeavour Blue
  - Stratos Dark Blue
  - TransLink Accent Yellow
- **Beautiful Glassmorphism Design**: Staggered list animations, elegant gradients, and modern card layouts.
- **Intuitive Inputs**: Large, accessible text fields for quickly punching in Stop IDs and Route Numbers while on the go.
- **Live Arrival Cards**: Easy-to-read layout showing destination, exact minutes until arrival, and clear delay indicators.

> **Note**: The application currently runs with a mock `TransitService` providing dummy data to showcase the dynamic UI. The underlying architecture is set up seamlessly to integrate the SMS (33333) or API service.

## 🚀 Getting Started

To run this project locally, ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/JoelV1234/nextbus.git
   ```
2. **Navigate to the directory**:
   ```bash
   cd nextbus
   ```
3. **Get dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the app**:
   ```bash
   flutter run
   ```

## 📂 Project Structure

- `lib/models/`: Contains the fundamental data structures (`BusArrival`, `BusStop`).
- `lib/services/`: Where the Transit API / SMS service logic lives.
- `lib/theme/`: Comprehensive `AppTheme` definitions defining typography, colors, and layout shapes.
- `lib/ui/`: Contains all screens and widgets, separated logically into `screens/` and `widgets/` directories.

## 🛠️ Built With

- **[Flutter](https://flutter.dev/)** - UI Toolkit for building natively compiled applications for mobile, web, and desktop.
- **Dart** - The modern programming language powering Flutter.
