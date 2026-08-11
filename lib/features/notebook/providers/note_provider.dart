import 'package:flutter/material.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All'; // Internal key for "All" category

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Get localized category names for display
  List<String> getCategories(LocalizationProvider loc) {
    return [
      loc.loc.categoryAll,
      loc.loc.categoryGeneral,
      loc.loc.categoryFinance,
      loc.loc.categoryGoals,
    ];
  }

  // Get internal category key from localized name
  String getCategoryKey(String localizedCategory, LocalizationProvider loc) {
    final categories = getCategories(loc);
    if (localizedCategory == categories[0]) return 'All';
    if (localizedCategory == categories[1]) return 'General';
    if (localizedCategory == categories[2]) return 'Finance';
    if (localizedCategory == categories[3]) return 'Goals';
    return localizedCategory; // fallback
  }

  NoteProvider() {
    loadNotes();
  }

  /// โหลดข้อมูลบันทึกทั้งหมดจาก SQLite
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await DatabaseHelper.instance.getAllNotes();
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ค้นหาตามคำค้นและหมวดหมู่
  List<NoteModel> get filteredNotes {
    return _notes.where((note) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || note.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  /// ค้นหาตามคำค้นและหมวดหมู่ (with localized categories)
  List<NoteModel> getFilteredNotesWithLocalization(LocalizationProvider loc) {
    // Convert selected localized category to internal key
    final selectedCategoryKey = getCategoryKey(_selectedCategory, loc);
    
    return _notes.where((note) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());

      // Handle both internal keys and localized names in database
      final noteCategoryKey = getCategoryKey(note.category, loc);
      final matchesCategory =
          selectedCategoryKey == 'All' || noteCategoryKey == selectedCategoryKey;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  /// เปลี่ยนคำค้นหา
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// เปลี่ยนหมวดหมู่ที่เลือก
  void setCategory(String category, [LocalizationProvider? loc]) {
    if (loc != null) {
      // Store the localized category name
      // _selectedCategory = category;
      _selectedCategory = getCategoryKey(category, loc);
    } else {
      // Store the internal key directly
      _selectedCategory = category;
    }
    notifyListeners();
  }

  /// เพิ่มบันทึกใหม่
  Future<bool> addNote({
    required String title,
    required String content,
    required int colorValue,
    required String date,
    String category = 'General',
  }) async {
    try {
      final note = NoteModel(
        title: title,
        content: content,
        colorValue: colorValue,
        date: date,
        category: category,
      );

      final id = await DatabaseHelper.instance.insertNote(note);
      if (id > 0) {
        await loadNotes();
        return true;
      }
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
    return false;
  }

  /// แก้ไขบันทึก
  Future<bool> updateNote(NoteModel note) async {
    try {
      final result = await DatabaseHelper.instance.updateNote(note);
      if (result > 0) {
        await loadNotes();
        return true;
      }
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
    return false;
  }

  /// ลบบันทึก
  Future<bool> deleteNote(int id) async {
    try {
      final result = await DatabaseHelper.instance.deleteNote(id);
      if (result > 0) {
        await loadNotes();
        return true;
      }
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
    return false;
  }

  /// สลับสถานะปักหมุด
  Future<void> togglePin(NoteModel note) async {
    if (note.id == null) return;
    try {
      final newPinStatus = !note.isPinned;
      await DatabaseHelper.instance.toggleNotePin(note.id!, newPinStatus);
      await loadNotes();
    } catch (e) {
      debugPrint('Error toggling pin: $e');
    }
  }
}