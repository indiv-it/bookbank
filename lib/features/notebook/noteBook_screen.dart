import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/features/notebook/providers/note_provider.dart';
import 'package:bookbank/features/notebook/widgets/empty_notes_view.dart';
import 'package:bookbank/features/notebook/widgets/note_card.dart';
import 'package:bookbank/features/notebook/widgets/note_editor_dialog.dart';
import 'package:bookbank/features/notebook/widgets/note_search_bar.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class NoteBookScreen extends StatefulWidget {
  const NoteBookScreen({super.key});

  @override
  State<NoteBookScreen> createState() => _NoteBookScreenState();
}

class _NoteBookScreenState extends State<NoteBookScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  void _showDeleteConfirmation(BuildContext context, NoteModel note) {
    final theme = Theme.of(context);
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    final loc = Provider.of<LocalizationProvider>(context, listen: false).loc;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: theme.colorScheme.onSurfaceVariant),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
            SizedBox(width: 8.w),
            Text(loc.confirmDelete),
          ],
        ),
        content: Text(
          '${loc.confirmDeleteNote} "${note.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              loc.cancel,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (note.id != null) {
                final success = await noteProvider.deleteNote(note.id!);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                        left: 16.w,
                        right: 16.w,
                      ),
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: AppColors.background,
                              width: 3,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: AppColors.background,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                loc.noteDeleted,
                                style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text(loc.delete),
          ),
        ],
      ),
    );
  }

  void _showNoteDetailDialog(BuildContext context, NoteModel note) {
    final theme = Theme.of(context);
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final loc = Provider.of<LocalizationProvider>(context, listen: false).loc;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: theme.colorScheme.onSurfaceVariant),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: 500.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Tag & Color
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Color(note.colorValue),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(note.colorValue).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      note.category,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: note.isPinned
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      noteProvider.togglePin(note);
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Title
              Text(
                note.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),

              // Date
              Text(
                '${loc.recordedOn} : ${note.date}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Divider(height: 24),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    note.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showDeleteConfirmation(context, note);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                      size: 18.sp,
                    ),
                    label: Text(
                      loc.delete,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      NoteEditorDialog.show(context, noteToEdit: note);
                    },
                    icon: Icon(Icons.edit, size: 18.sp),
                    label: Text(loc.edit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteProvider = Provider.of<NoteProvider>(context);
    final locProvider = Provider.of<LocalizationProvider>(context);
    final filteredNotes = noteProvider.getFilteredNotesWithLocalization(locProvider);

    final loc = locProvider.loc;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 120.h), // Lower bottom navigation bar
        child: FloatingActionButton.extended(
          onPressed: () => NoteEditorDialog.show(context),
          backgroundColor: theme.colorScheme.onSurface,
          foregroundColor: theme.scaffoldBackgroundColor,
          label: Text(loc.add, style: TextStyle(fontSize: AppSize.xs.sp)),
          icon: Icon(Icons.add, size: 18.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_square,
                        color: theme.colorScheme.onSurface,
                        size: 24.sp,
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.notebook,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: AppSize.l.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            loc.notesSubtitle,
                            style: TextStyle(
                              fontSize: AppSize.xs.sp,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      '${filteredNotes.length} ${loc.items}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Search & Category Filters
              const NoteSearchBar(),
              SizedBox(height: 16.h),

              // Note Content List /Grid View
              Expanded(
                child: noteProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.onSurface,
                        ),
                      )
                    : filteredNotes.isEmpty
                    ? EmptyNotesView(
                        onAddNote: () => NoteEditorDialog.show(context),
                      )
                    : RefreshIndicator(
                        onRefresh: () => noteProvider.loadNotes(),
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 90.h),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            return NoteCard(
                              note: note,
                              onTap: () => _showNoteDetailDialog(context, note),
                              onEdit: () => NoteEditorDialog.show(
                                context,
                                noteToEdit: note,
                              ),
                              onDelete: () =>
                                  _showDeleteConfirmation(context, note),
                              onTogglePin: () => noteProvider.togglePin(note),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
