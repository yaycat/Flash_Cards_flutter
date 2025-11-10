# Flash Cards

A simple and easy-to-use app for creating and studying flashcards, built on Flutter.

## About the project

This app was created as a learning project to help users learn new words, terms, or any other information using spaced repetition. The app allows you to create your own decks of cards, add terms and definitions, and then take quizzes or use the memorization mode.

## Features

.Collection Creation: You can create collections where you can store cards with information.  
.Create Cards: You can create cards that will be saved to a selected collection.  
.Learning Mode: Scroll through cards, memorizing information.  
.Local and Server Storage: Your collections and cards will be saved locally on your device and also on the Firebase server.  

## Stack

Framework: Flutter  
Language: Dart  
Backend as a Service: Firebase  
  firebase_auth: User authentication  
  firebase_core: Core Firebase initialization  
  google_sign_in: Google Sign-in integration  
  cloud_firestore: Cloud NoSQL database  
Local storage: shared_preferences  
Animations: lottie  
State Management: ValueNotifier  

## Getting Started

Follow these steps to get a local copy of the project up and running.

1. Clone the repository:  
git clone https://github.com/yaycat/Flash_Cards_flutter.git  
cd Flash_Cards_flutter  

2. Install dependencies:  
flutter pub get  

3. Run the application:  
flutter run  

## Project Structure

lib/  
├── data/  
│   ├── notifiers/         # ValueNotifiers for state management  
│   └── constants.dart     # App-wide constants  
│  
├── views/  
│   ├── pages/             # Main screens of the application  
│   │   ├── login_page.dart  
│   │   ├── home_page.dart  
│   │   ├── profile_page.dart  
│   │   ├── ... (other screens)  
│   │   └── widget_tree.dart   # Handles auth state logic  
│   │  
│   └── widgets/           # Reusable UI components  
│       ├── app_bar_widget.dart  
│       ├── navbar_widget.dart  
│       └── ... (other widgets)  
│  
├── firebase_options.dart  # Firebase configuration  
└── main.dart              # Main application entry point  

##

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
