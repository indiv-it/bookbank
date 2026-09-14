import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class TransferPopup extends StatefulWidget {
  final String sourceGroupId;
  final String sourceGroupName;
  final Color sourceGroupColor;
  final IconData sourceGroupIcon;
  final double sourceGroupAmount;

  final String targetGroupId;
  final String targetGroupName;
  final Color targetGroupColor;
  final IconData targetGroupIcon;

  const TransferPopup({
    super.key,
    required this.sourceGroupId,
    required this.sourceGroupName,
    required this.sourceGroupColor,
    required this.sourceGroupIcon,
    required this.sourceGroupAmount,
    required this.targetGroupId,
    required this.targetGroupName,
    required this.targetGroupColor,
    required this.targetGroupIcon,
  });

  @override
  State<TransferPopup> createState() => _TransferPopupState();
}

class _TransferPopupState extends State<TransferPopup>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _validate() {
    final text = _amountController.text.trim();
    final amount = double.tryParse(text);
    final loc = context.read<LocalizationProvider>().loc;

    if (text.isEmpty || amount == null || amount <= 0) {
      setState(() => _errorText = loc.pleaseEnterAmount);
      return;
    }

    if (amount > widget.sourceGroupAmount) {
      setState(() => _errorText = loc.transferAmountNotEnough);
      return;
    }

    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locProvider = Provider.of<LocalizationProvider>(context);
    final loc = context.watch<LocalizationProvider>().loc;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: theme.colorScheme.onSurfaceVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.transferTitle,
                style: TextStyle(fontSize: AppSize.sm.sp),
              ),
              SizedBox(height: 20.h),

              // Source → Target visual
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GroupChip(
                    name: widget.sourceGroupName,
                    color: widget.sourceGroupColor,
                    icon: widget.sourceGroupIcon,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.grey,
                          size: 22.sp,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          loc.transferTo,
                          style: TextStyle(
                            fontSize: AppSize.xs.sp,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _GroupChip(
                    name: widget.targetGroupName,
                    color: widget.targetGroupColor,
                    icon: widget.targetGroupIcon,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Balance info
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: widget.sourceGroupColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: widget.sourceGroupColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 16.sp,
                      color: widget.sourceGroupColor,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${loc.transferRemaining} ',
                      style: TextStyle(
                        fontSize: AppSize.xs.sp,
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      locProvider.formatAmount(widget.sourceGroupAmount),
                      style: TextStyle(
                        fontSize: AppSize.xs.sp,
                        fontWeight: FontWeight.bold,
                        color: widget.sourceGroupColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Amount Input
              TextField(
                controller: _amountController,
                focusNode: _focusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: TextStyle(fontSize: AppSize.sm.sp),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    color: AppColors.grey.withValues(alpha: 0.5),
                    fontSize: AppSize.sm.sp,
                  ),
                  prefixText: locProvider.currencySymbol,
                  prefixStyle: TextStyle(
                    fontSize: AppSize.l.sp,
                    color: AppColors.grey,
                  ),
                  errorText: _errorText,
                  errorStyle: TextStyle(fontSize: AppSize.xs.sp),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: LightColors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.outline.withValues(alpha: 0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: widget.sourceGroupColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
                onSubmitted: (_) => _validate(),
              ),

              SizedBox(height: 20.h),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 45.h,
                child: Expanded(
                  child: ElevatedButton(
                    onPressed: _validate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.sourceGroupColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      loc.transferMoney,
                      style: TextStyle(
                        fontSize: AppSize.s.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 45.h,
                child: Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(loc.cancel),
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

// ── Helper: Group Chip ────────────────────────────────────────────────────────

class _GroupChip extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;

  const _GroupChip({
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: color),
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 70.w,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: AppSize.xs.sp),
          ),
        ),
      ],
    );
  }
}

