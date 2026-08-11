import 'package:flutter/material.dart';
import 'package:bookbank/features/menu/editGroup/editGroup_sgreen.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/core/localization/localization_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<LocalizationProvider>(
      builder: (context, locProvider, child) {
        final loc = locProvider.loc;

        return Column(
          children: [
            // Header app
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      loc.appName,
                      style: textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.menu, size: 20.sp),
                  offset: Offset(70.w, 50.h),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.surface,
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: theme.colorScheme.outline),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: BorderSide(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  onSelected: (String value) {
                    if (value == 'edit_group') {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            Dialog(child: EditGroupSgreen()),
                      );
                    }
                    // Language & Currency are handled inline via submenus
                  },
                  itemBuilder: (BuildContext context) => [
                    // ── Edit Group ──────────────────────────────────────────
                    PopupMenuItem<String>(
                      value: 'edit_group',
                      child: _MenuRow(
                        icon: Icons.edit,
                        label: loc.editGroup,
                      ),
                    ),

                    // ── Dark Theme ──────────────────────────────────────────
                    PopupMenuItem<String>(
                      enabled: false, // handled by Switch inside
                      padding: EdgeInsets.zero,
                      child: _DarkThemeRow(label: loc.darkTheme),
                    ),

                    // ── Change Language ─────────────────────────────────────
                    _buildLanguageItem(context, loc, locProvider, theme),

                    // ── Change Currency ─────────────────────────────────────
                    _buildCurrencyItem(context, loc, locProvider, theme),

                    // ── About ───────────────────────────────────────────────
                    PopupMenuItem<String>(
                      value: 'about',
                      child: _MenuRow(
                        icon: Icons.info,
                        label: loc.about,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ── Language submenu popup item ─────────────────────────────────────────────
  PopupMenuItem<String> _buildLanguageItem(
    BuildContext context,
    dynamic loc,
    LocalizationProvider locProvider,
    ThemeData theme,
  ) {
    return PopupMenuItem<String>(
      enabled: false,
      padding: EdgeInsets.zero,
      child: _ExpandableMenuItem(
        icon: Icons.language,
        label: loc.changeLanguage,
        badge:
            '${locProvider.language.flag} ${locProvider.language.label}',
        theme: theme,
        children: AppLanguage.values.map((lang) {
          final isSelected = locProvider.language == lang;
          return _SubMenuItem(
            flag: lang.flag,
            label: lang.label,
            isSelected: isSelected,
            theme: theme,
            onTap: () {
              locProvider.setLanguage(lang);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }

  // ── Currency submenu popup item ─────────────────────────────────────────────
  PopupMenuItem<String> _buildCurrencyItem(
    BuildContext context,
    dynamic loc,
    LocalizationProvider locProvider,
    ThemeData theme,
  ) {
    return PopupMenuItem<String>(
      enabled: false,
      padding: EdgeInsets.zero,
      child: _ExpandableMenuItem(
        icon: Icons.currency_exchange,
        label: loc.changeCurrency,
        badge:
            '${locProvider.currency.symbol} ${locProvider.currency.code}',
        theme: theme,
        children: AppCurrency.values.map((curr) {
          final isSelected = locProvider.currency == curr;
          return _SubMenuItem(
            flag: curr.symbol,
            label: '${curr.label} (${curr.code})',
            isSelected: isSelected,
            theme: theme,
            onTap: () {
              locProvider.setCurrency(curr);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}

// ─── Reusable Menu Row ────────────────────────────────────────────────────────

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ─── Dark Theme Row with Switch ───────────────────────────────────────────────

class _DarkThemeRow extends StatelessWidget {
  final String label;

  const _DarkThemeRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.nightlight_round_rounded, size: 16.sp),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          Transform.scale(
            scale: 0.6,
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color.fromARGB(255, 75, 87, 255),
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Expandable Menu Item with Submenu ────────────────────────────────────────

class _ExpandableMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String badge;
  final ThemeData theme;
  final List<Widget> children;

  const _ExpandableMenuItem({
    required this.icon,
    required this.label,
    required this.badge,
    required this.theme,
    required this.children,
  });

  @override
  State<_ExpandableMenuItem> createState() => _ExpandableMenuItemState();
}

class _ExpandableMenuItemState extends State<_ExpandableMenuItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _arrowAngle;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowAngle = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Column(
      children: [
        // ── Header row ───────────────────────────────────────────────────────
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Icon(widget.icon, size: 16.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Badge showing current selection
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    widget.badge,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                // Animated chevron
                RotationTransition(
                  turns: _arrowAngle,
                  child: Icon(
                    Icons.expand_more,
                    size: 16.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Animated children ────────────────────────────────────────────────
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            margin: EdgeInsets.only(left: 16.w, right: 8.w, bottom: 4.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            child: Column(children: widget.children),
          ),
        ),
      ],
    );
  }
}

// ─── Sub Menu Item ────────────────────────────────────────────────────────────

class _SubMenuItem extends StatelessWidget {
  final String flag;
  final String label;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap;

  const _SubMenuItem({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 14.sp,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
