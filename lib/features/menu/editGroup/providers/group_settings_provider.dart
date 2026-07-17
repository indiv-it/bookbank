import 'package:flutter/foundation.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';

class GroupSettingsProvider extends ChangeNotifier {
  List<GroupSettings> _groupSettings = [];
  bool _isLoading = false;

  List<GroupSettings> get groupSettings => _groupSettings;
  bool get isLoading => _isLoading;

  GroupSettingsProvider() {
    loadGroupSettings();
  }

  Future<void> loadGroupSettings() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final settings = await DatabaseHelper.instance.getAllGroupSettings();
      _groupSettings = settings;
    } catch (e) {
      debugPrint('Error loading group settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  GroupSettings? getGroupSettings(String groupId) {
    try {
      return _groupSettings.firstWhere(
        (s) => s.groupId == groupId,
        orElse: () => GroupSettings(
          groupId: groupId,
          groupName: groupId,
          iconCodePoint: 0xe145,
          colorValue: 0xFF2196F3,
          savingsGoalEnabled: false,
          savingsGoalAmount: 0,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> updateGroupSettings(GroupSettings settings) async {
    try {
      await DatabaseHelper.instance.updateGroupSettings(settings);
      await loadGroupSettings();
    } catch (e) {
      debugPrint('Error updating group settings: $e');
    }
  }

  Future<void> refresh() async {
    await loadGroupSettings();
  }
}
