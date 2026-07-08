import 'package:bookbank/Core/Theme/app_style.dart';
import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  final String titel;
  final String? onKey;
  final VoidCallback function;
  final IconData? icon;

  const ListButton({
    super.key,
    required this.titel,
    required this.onKey,
    required this.function,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      color: AppColors.card,
      child: TextButton(
        onPressed: function,
        style: TextButton.styleFrom(
          minimumSize: const Size(155, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          foregroundColor: onKey == titel ? AppColors.card : AppColors.black,
          backgroundColor: onKey == titel ? AppColors.black : AppColors.card,
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: AppSize.s.fontSize,
                    color: onKey == titel ? AppColors.card : AppColors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(titel, style: TextStyle(fontSize: AppSize.s.fontSize)),
                ],
              )
            : Text(titel, style: TextStyle(fontSize: AppSize.s.fontSize)),
      ),
    );
  }
}
