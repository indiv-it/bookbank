import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookbank/core/localization/app_localizations.dart';
import 'package:intl/intl.dart';

// ─── Supported Languages ──────────────────────────────────────────────────────

enum AppLanguage {
  thai('th', 'ไทย', '🇹🇭'),
  english('en', 'English', '🇬🇧'),
  chinese('zh', '中文', '🇨🇳');

  final String code;
  final String label;
  final String flag;

  const AppLanguage(this.code, this.label, this.flag);
}

// ─── Supported Currencies ────────────────────────────────────────────────────

enum AppCurrency {
  baht('THB', '฿ ', 'บาท', 1.0),
  dollar('USD', '\$ ', 'Dollar', 0.028),
  yuan('CNY', '¥ ', '人民币', 0.20);

  final String code;
  final String symbol;
  final String label;
  final double rateFromBaht; // Exchange rate relative to Baht

  const AppCurrency(this.code, this.symbol, this.label, this.rateFromBaht);
}

// ─── Localization Provider ────────────────────────────────────────────────────

class LocalizationProvider extends ChangeNotifier {
  static const String _langKey = 'app_language';
  static const String _currencyKey = 'app_currency';

  AppLanguage _language = AppLanguage.thai;
  AppCurrency _currency = AppCurrency.baht;

  AppLanguage get language => _language;
  AppCurrency get currency => _currency;

  AppLocalizations get loc => AppLocalizations(_language.code);

  String get currencySymbol => _currency.symbol;
  String get currencyCode => _currency.code;
  double get exchangeRate => _currency.rateFromBaht;

  LocalizationProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final langCode = prefs.getString(_langKey);
    if (langCode != null) {
      _language = AppLanguage.values.firstWhere(
        (l) => l.code == langCode,
        orElse: () => AppLanguage.thai,
      );
    }

    final currencyCode = prefs.getString(_currencyKey);
    if (currencyCode != null) {
      _currency = AppCurrency.values.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => AppCurrency.baht,
      );
    }

    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) return;
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, language.code);
    notifyListeners();
  }

  Future<void> setCurrency(AppCurrency currency) async {
    if (_currency == currency) return;
    _currency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency.code);
    notifyListeners();
  }

  /// Convert an amount from THB to the current currency
  double convertAmount(double amountInBaht) {
    return amountInBaht * _currency.rateFromBaht;
  }

  /// Format an amount with the current currency symbol
  String formatAmount(double amountInBaht) {
    final converted = convertAmount(amountInBaht);
    final hasDecimals = converted != converted.truncate();
    final formatter = NumberFormat.currency(
      locale: _language.code == 'th' ? 'th_TH' : 'en_US',
      symbol: _currency.symbol,
      decimalDigits: hasDecimals ? 2 : 0,
    );
    return formatter.format(converted);
  }
}
