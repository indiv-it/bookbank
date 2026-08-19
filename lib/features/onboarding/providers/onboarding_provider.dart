import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  static const String _onboardingKey = 'onboarding_completed';

  bool _isCompleted = false;
  bool _isLoaded = false;

  bool get isCompleted => _isCompleted;
  bool get isLoaded => _isLoaded;

  OnboardingProvider() {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isCompleted = prefs.getBool(_onboardingKey) ?? false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  /// For development/testing: reset onboarding so it shows again
  Future<void> resetOnboarding() async {
    _isCompleted = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, false);
    notifyListeners();
  }
}
