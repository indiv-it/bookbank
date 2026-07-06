import 'package:flutter/material.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/utils/record/record_actions.dart';
import 'package:bookbank/utils/record/record_date_filter.dart';
import 'package:bookbank/utils/record/record_filter.dart';
import 'package:bookbank/utils/record/record_utils.dart';
import 'package:bookbank/Widgets/record_widgets.dart';

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
    // Note: since buildFilterTab is in record_widgets, we might need to modify it
    // to accept theme values or rely on context internally, but for now we'll just use it.
    return buildFilterTab(
      value: value,
      selectedFilter: _filter,
      icon: icon,
      label: label,
      onTap: () => setState(() => _filter = value),
    );
  }

  Widget _buildRecordRow(MyData item) {
    return buildRecordRow(item, (action) => _handleMenuAction(action, item));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 45, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, size: 28, color: theme.iconTheme.color),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Record', style: textTheme.bodyMedium),
                    Text(
                      'Transaction History',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 18, bottom: 12),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(50),
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
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(50),
                      color: theme.colorScheme.surface,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: AppSize.l,
                          color: theme.iconTheme.color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: textTheme.bodySmall,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
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
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Container(
                    height: 48,
                    width: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _hasDateRange
                            ? theme.colorScheme.onSurface
                            : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: theme.colorScheme.surface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: _selectDateRange,
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                _dateRangeLabel,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: _hasDateRange
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _hasDateRange
                              ? _clearDateFilter
                              : _selectDateRange,
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            _hasDateRange ? Icons.close : Icons.calendar_today,
                            size: 18,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
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
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
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
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(color: AppColors.border, height: 1),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filtered.isEmpty
                          ? Center(
                              child: Text(
                                'No records found',
                                style: textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
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
      ),
    );
  }
}
