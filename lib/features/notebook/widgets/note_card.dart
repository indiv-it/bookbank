import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.watch<LocalizationProvider>().loc;
    final cardColor = Color(note.colorValue);

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: note.isPinned
              ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
              : theme.colorScheme.outline,
          width: note.isPinned ? 1.5 : 1.0,
        ),
      ),
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row (Color bar, Category tag, Pin, Actions)
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      note.category,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 18.sp,
                      color: note.isPinned
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(4.w),
                    onPressed: onTogglePin,
                    tooltip: note.isPinned ? loc.unpin : loc.pin,
                  ),
                  SizedBox(width: 4.w),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18.sp,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(4.w),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16.sp),
                            SizedBox(width: 8.w),
                            Text(loc.edit, style: TextStyle(fontSize: 13.sp)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 16.sp),
                            SizedBox(width: 8.w),
                            Text(loc.delete, style: TextStyle(fontSize: 13.sp, color: theme.colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Title
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 6.h),

              // Content preview
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12.h),

              // Date Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        note.date,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
