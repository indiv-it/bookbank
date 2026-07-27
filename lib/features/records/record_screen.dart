import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/features/records/utils/record_actions.dart';
import 'package:bookbank/features/records/utils/record_date_filter.dart';
import 'package:bookbank/features/records/utils/record_filter.dart';
import 'package:bookbank/features/records/utils/record_utils.dart';
import 'package:bookbank/features/records/widgets/record_widgets.dart';
import 'package:bookbank/features/menu/editGroup/providers/group_settings_provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<MyData> _allTransactions = [];
  RecordFilter _filter = RecordFilter.all;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();
    if (!mounted) return;
    setState(() {
      _allTransactions = data;
      _isLoading = false;
    });
  }

  List<MyData> get _filteredTransactions {
    final query = _searchController.text.trim().toLowerCase();

    var filtered = _allTransactions.where((item) {
      if (_filter == RecordFilter.income && item.moneyType != 'income') {
        return false;
      }
      if (_filter == RecordFilter.expense && item.moneyType != 'expense') {
        return false;
      }
      return true;
    }).toList();

    filtered = filterByDateRange(
      filtered,
      _startDate,
      _endDate,
      (item) => item.date ?? '',
    );

    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        final name = getItemName(item).toLowerCase();
        return name.contains(query);
      }).toList();
    }

    return filtered;
  }

  bool get _hasDateRange => hasDateRange(_startDate, _endDate);
  String get _dateRangeLabel => getDateRangeLabel(_startDate, _endDate);

  Future<void> _selectDateRange() async {
    final picked = await selectDateRange(context, _startDate, _endDate);
    if (picked != null && mounted) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _viewRecord(MyData item) async {
    await viewRecord(context, item);
  }

  Future<void> _editRecord(MyData item) async {
    await editRecord(context, item, _loadData);
  }

  Future<void> _deleteRecord(MyData item) async {
    await deleteRecord(context, item, _loadData);
  }

  void _handleMenuAction(String action, MyData item) {
    if (action == 'view') {
      _viewRecord(item);
    } else if (action == 'edit') {
      _editRecord(item);
    } else if (action == 'delete') {
      _deleteRecord(item);
    }
  }

  Widget _buildFilterTab({
    required RecordFilter value,
    required IconData icon,
    required String label,
  }) {
    return buildFilterTab(
      context: context,
      value: value,
      selectedFilter: _filter,
      icon: icon,
      label: label,
      onTap: () => setState(() => _filter = value),
    );
  }

  Widget _buildRecordRow(MyData item) {
    return buildRecordRow(context, item, (action) => _handleMenuAction(action, item));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<GroupSettingsProvider>(
      builder: (context, groupProvider, child) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  45.h,
                  24.w,
                  24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 28.sp,
                          color: theme.iconTheme.color,
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Record',
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            Text(
                              'Transaction History',
                              style: textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(
                      height: 50.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 18.h,
                        bottom: 12.h,
                      ),
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(50.r),
                        color: theme.colorScheme.surface,
                      ),
                      child: Row(
                        children: [
                          _buildFilterTab(
                            value: RecordFilter.all,
                            icon: Icons.filter_list,
                            label: 'All',
                          ),
                          _buildFilterTab(
                            value: RecordFilter.income,
                            icon: Icons.trending_up,
                            label: 'Income',
                          ),
                          _buildFilterTab(
                            value: RecordFilter.expense,
                            icon: Icons.trending_down,
                            label: 'Expense',
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(50.r),
                              color: theme.colorScheme.surface,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 20.sp,
                                  color: theme.iconTheme.color,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      hintStyle: textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                        fontSize: 14.sp,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                                if (_searchController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 18.sp,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Flexible(
                          child: Container(
                            height: 48.h,
                            width: 150.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _hasDateRange
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(50.r),
                              color: theme.colorScheme.surface,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: InkWell(
                                    onTap: _selectDateRange,
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      child: Text(
                                        _dateRangeLabel,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: _hasDateRange
                                              ? theme.colorScheme.onSurface
                                              : theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                InkWell(
                                  onTap: _hasDateRange
                                      ? _clearDateFilter
                                      : _selectDateRange,
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Icon(
                                    _hasDateRange
                                        ? Icons.close
                                        : Icons.calendar_today,
                                    size: 18.sp,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16.h),
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: theme.colorScheme.outline),
                          color: theme.colorScheme.surface,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Amount',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Position',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Date',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Divider(color: theme.colorScheme.outline, height: 1),
                            Expanded(
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : filtered.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No records found',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: filtered.length,
                                      itemBuilder: (context, index) {
                                        return _buildRecordRow(filtered[index]);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
