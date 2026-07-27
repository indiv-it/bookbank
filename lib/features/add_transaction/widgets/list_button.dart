import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  final String buttonKey;
  final String titel;
  final String? onKey;
  final VoidCallback function;
  final IconData? icon;

  const ListButton({
    super.key,
    required this.buttonKey,
    required this.titel,
    required this.onKey,
    required this.function,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 170,
      color: theme.colorScheme.surface,
      child: TextButton(
        onPressed: function,
        style: TextButton.styleFrom(
          minimumSize: const Size(155, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: theme.colorScheme.surface, width: 2),
          ),
          foregroundColor: buttonKey == onKey
              ? theme.colorScheme.surface
              : theme.colorScheme.onSurface,
          backgroundColor: buttonKey == onKey
              ? theme.colorScheme.onSurface
              : theme.colorScheme.surface,
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: AppSize.s,
                    color: buttonKey == onKey
                        ? theme.colorScheme.surface
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(titel, style: TextStyle(fontSize: AppSize.s)),
                ],
              )
            : Text(titel, style: TextStyle(fontSize: AppSize.s)),
      ),
    );
  }
}
